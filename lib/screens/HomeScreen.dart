import 'dart:async';
import 'dart:io';

import 'package:call_log/call_log.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state/phone_state.dart';
import 'package:provider/provider.dart';
import 'package:telecaliingcrm/Services/UserApi.dart';
import 'package:telecaliingcrm/providers/DashBoardProvider.dart';
import 'package:telecaliingcrm/providers/UserDetailsProvider.dart';
import 'package:telecaliingcrm/screens/FollowupsScreen.dart';
import 'package:telecaliingcrm/screens/LeadsScreen.dart';
import 'package:telecaliingcrm/utils/ColorConstants.dart';
import 'package:telecaliingcrm/utils/constants.dart';

import '../model/DashBoardModel.dart';
import '../providers/ConnectivityProviders.dart';
import '../services/otherservices.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  // int _page = 0;
  File? _image; // To store the selected image
  bool isLoading = false; // Loading state
  XFile? _pickedFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, // Use ImageSource.camera for camera
      imageQuality: 100,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Set the selected image file
        print("Image: ${_image?.path}"); // Print the image path for debugging
      });
    } else {
      print("No image selected.");
    }
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  int currentIndex = 0;
  bool isCalling = false;
  late Timer callDurationTimer;
  int callDuration = 0; // Track call duration in seconds
  String mobile_nnumber = "";
  bool isPaused = false;
  bool isCallOngoing = false;
  late StreamSubscription<PhoneState> _phoneStateSubscription;

  @override
  void initState() {
    GetDashBoardDetails();
    Provider.of<ConnectivityProviders>(context, listen: false)
        .initConnectivity();
    _initializeNotifications();
    _initializePhoneStateListener();
    _requestPermission();
    super.initState();
  }

  @override
  void dispose() {
    Provider.of<ConnectivityProviders>(context, listen: false).dispose();
    super.dispose();
  }

  List<PhoneNumbers>? phoneNumbers;
  Future<void> GetDashBoardDetails() async {
    final dashboard_provider =
        Provider.of<DashboardProvider>(context, listen: false);
    dashboard_provider.fetchDashBoardDetails();
  }

  Future<void> _initializeNotifications() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Request phone permissions
  Future<void> _requestPermission() async {
    var status = await Permission.phone.request();
    if (status.isGranted) {
    } else {
      // Handle permission denial if needed
      print('Permission Denied');
    }
  }

  // Initialize the phone state listener
  void _initializePhoneStateListener() {
    if (Platform.isAndroid) {
      _phoneStateSubscription = PhoneState.stream.listen((PhoneState state) {
        _handlePhoneStateChange(state);
      });
    }
  }

  // Handle different phone state changes
  void _handlePhoneStateChange(PhoneState state) {
    switch (state.status) {
      case PhoneStateStatus.CALL_INCOMING:
      case PhoneStateStatus.CALL_STARTED:
        // Call started, start tracking the duration
        _startCallDurationTracking();
        break;
      case PhoneStateStatus.CALL_ENDED:
        // Call ended, stop the duration timer and show the duration dialog
        _endCallAndShowDuration();
        break;
      default:
        break;
    }
  }

  // Start the call process
  Future<void> _startCallingProcess() async {
    setState(() {
      isCalling = true;
      currentIndex = 0;
      isPaused = false;
    });
    _scheduleNextCall();
  }

  // Schedule the next call
  Future<void> _scheduleNextCall() async {
    if (currentIndex < phoneNumbers!.length && !isPaused) {
      String phoneNumber = phoneNumbers![currentIndex].number!;
      print("Dialing: $phoneNumber");
      // Start the call using flutter_phone_direct_caller
      await FlutterPhoneDirectCaller.callNumber(phoneNumber);
      setState(() {
        currentIndex++;
      });
    }
  }

  // Start tracking call duration
  void _startCallDurationTracking() {
    if (!isCallOngoing) {
      isCallOngoing = true;
      callDuration = 0;
      callDurationTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          callDuration++;
        });
      });
    }
  }

// Stop the call duration tracking and show the duration dialog
  void _endCallAndShowDuration() {
    if (isCallOngoing) {
      callDurationTimer.cancel();
      isCallOngoing = false;
    }

    // Wait for 5 seconds before retrieving the call duration from the call log
    Future.delayed(Duration(seconds: 3), () {
      _retrieveCallDurationFromCallLog();
    });
  }

// Retrieve the call duration from the call log
  Future<void> _retrieveCallDurationFromCallLog() async {
    Iterable<CallLogEntry> logs = await CallLog.get();
    String lastDialedNumber = phoneNumbers![currentIndex - 1].number!;

    var sortedLogs = logs.toList()
      ..sort((a, b) {
        int timestampA = a.timestamp ?? 0;
        int timestampB = b.timestamp ?? 0;
        return timestampB.compareTo(timestampA); // Descending order
      });

    for (CallLogEntry log in sortedLogs) {
      if (log.number == lastDialedNumber && log.duration != null) {
        _onCallEnd(log.duration!, log.number!,phoneNumbers![currentIndex - 1].id!);
        break;
      }
    }
  }

  // Handle call end, update call duration, and show dialog
  void _onCallEnd(int duration, String number,int id) {
    setState(() {
      callDuration = duration;
      mobile_nnumber = number;
    });

    _showCallDurationDialog(mobile_nnumber,id);

    // After showing the dialog, remove the number from the list
    setState(() {
      phoneNumbers!.removeAt(currentIndex - 1); // Remove the last dialed number
      currentIndex =
          currentIndex > 0 ? currentIndex - 1 : 0; // Correct the index
    });
  }

  void _showCallDurationDialog(mobile_nnumber,id) {
    String? selectedStatus; // Variable to hold the selected status
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Call Duration",
            style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ),
          content: StatefulBuilder(builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Show the call duration
                Text("Duration: $callDuration seconds",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
                Text("Mobile Number: $mobile_nnumber",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
                // Radio buttons for selecting the status
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  dense: true,
                  title: Text(
                    "NOT LIFTING",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  leading: Radio<String>(
                    value: "not_lifting",
                    visualDensity: VisualDensity.compact,
                    groupValue: selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  dense: true,
                  title: Text(
                    "NOT INTERESTED",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  leading: Radio<String>(
                    visualDensity: VisualDensity.compact,
                    value: "not_interested",
                    groupValue: selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  dense: true,
                  title: Text(
                    "INTERESTED",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  leading: Radio<String>(
                    value: "interested",
                    visualDensity: VisualDensity.compact,
                    groupValue: selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  dense: true,
                  title: Text(
                    "NOT CORRECT NUMBER",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  leading: Radio<String>(
                    value: "notcorrect_number",
                    visualDensity: VisualDensity.compact,
                    groupValue: selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value;
                      });
                    },
                  ),
                ),
              ],
            );
          }),
          actions: <Widget>[
            // Centered ElevatedButton for submit action
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // Background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Border radius
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Button padding
                ),
                onPressed: () {
                  if (selectedStatus != null) {
                    // Save the selected status (you can store it in a variable or database)
                    print("Selected Status: $selectedStatus");
                    // Close the dialog
                    Navigator.of(context).pop();
                    // Reset call duration
                    setState(() {
                      callDuration = 0;
                    });
                    updateCallStatus(id.toString(),selectedStatus,callDuration.toString());
                  } else {
                    // If no status is selected, show a message or do nothing
                    print("No status selected");
                  }
                },
                child: Text("Submit",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  fontFamily: "Poppins",
                  color: Colors.white
                ),),
              ),
            ),
          ],
        );
      },
    );
  }

  void updateCallStatus(id,callStatus,String callDuration) async {
    var result = await Userapi.UpdateCallStatusApi(id, callStatus, callDuration);
    if (result != null) {
      // Process the result here (e.g., display a message to the user)
      print("Response: $result");
      Future.delayed(Duration(seconds: 3), () {
        _scheduleNextCall(); // Start the next call if available
      });

    } else {
      print("Failed to update the call status.");
    }
  }


  // Pause/Resume the calling process
  void _togglePauseResume() {
    if (isPaused) {
      setState(() {
        isPaused = false;
      });
      _scheduleNextCall();
    } else {
      setState(() {
        isPaused = true;
      });
      // Optionally, you can cancel the call duration timer here if needed
      callDurationTimer.cancel();
    }
  }

  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    var connectiVityStatus = Provider.of<ConnectivityProviders>(context);
    return (connectiVityStatus.isDeviceConnected == "ConnectivityResult.wifi" ||
            connectiVityStatus.isDeviceConnected == "ConnectivityResult.mobile")
        ? Scaffold(
            key: _scaffoldKey,
            appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(80), // Set the desired height of the AppBar
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors
                    .transparent, // Make the AppBar background transparent
                elevation: 0, // Remove the default shadow of the AppBar
                flexibleSpace: Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xffffffff), // White color for the container
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset(0, 1),
                        blurRadius: 1,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // App icon
                      Image.asset(
                        'assets/telecalling_appicon.webp',
                        fit: BoxFit.contain,
                        width: w * 0.14,
                      ),
                      Spacer(),
                      // Greeting message
                      Container(
                        padding: EdgeInsets.all(8),
                        color: color30,
                        child: Text(
                          'HI! Ramakrishnamurthy',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Spacer(),
                      // Power icon
                      Icon(
                        Icons.power_settings_new,
                        size: 26,
                        color: color11,
                      ),
                      SizedBox(width: 18),
                      // Menu icon
                      InkResponse(
                        onTap: () {
                          _scaffoldKey.currentState?.openEndDrawer();
                        },
                        child: Icon(
                          Icons.menu,
                          size: 26,
                          color: color11,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [Container()],
              ),
            ),
            body: Consumer<DashboardProvider>(
                builder: (context, dashboardProvider, child) {
              final numbers = dashboardProvider.phoneNumbers;
              phoneNumbers=numbers;
              return SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                                w: w * 0.44,
                                context,
                                colors: color31,
                                child: Column(
                                  children: [
                                    text(
                                        context,
                                        dashboardProvider.todayCalls.toString(),
                                        46,
                                        fontfamily: 'Poppins',
                                        fontWeight: FontWeight.w500),
                                    text(context, 'Todays Calls', 14,
                                        fontfamily: 'Inter',
                                        fontWeight: FontWeight.w500),
                                  ],
                                ),
                              ),
                              container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                                w: w * 0.44,
                                context,
                                colors: color32,
                                child: Column(
                                  children: [
                                    text(
                                        context,
                                        dashboardProvider.pendingCalls
                                            .toString(),
                                        46,
                                        fontfamily: 'Poppins',
                                        fontWeight: FontWeight.w500),
                                    text(context, 'Pending Calls', 14,
                                        fontfamily: 'Inter',
                                        fontWeight: FontWeight.w500),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: h * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkResponse(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LeadScreen(),
                                      ));
                                },
                                child: container(
                                  w: w * 0.44,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  context,
                                  colors: color33,
                                  child: Column(
                                    children: [
                                      text(
                                          context,
                                          dashboardProvider.leadCount
                                              .toString(),
                                          46,
                                          fontfamily: 'Poppins',
                                          fontWeight: FontWeight.w500),
                                      text(context, 'Leads', 14,
                                          fontfamily: 'Inter',
                                          fontWeight: FontWeight.w500),
                                    ],
                                  ),
                                ),
                              ),
                              InkResponse(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FollowupsScreen(),
                                      ));
                                },
                                child: container(
                                  w: w * 0.44,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  context,
                                  colors: color30,
                                  child: Column(
                                    children: [
                                      text(
                                          context,
                                          dashboardProvider.followup_count
                                              .toString(),
                                          46,
                                          fontfamily: 'Poppins',
                                          fontWeight: FontWeight.w500),
                                      text(context, 'Follow Ups', 14,
                                          fontfamily: 'Inter',
                                          fontWeight: FontWeight.w500),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: w * 0.07),
                          containertext(context, onTap: () {
                            if (!isCalling) {
                              // Start the calling process
                              _startCallingProcess();
                            } else {
                              // Toggle between Pause and Resume
                              _togglePauseResume();
                            }
                          },
                              color: color28,
                              width: w * 0.4,
                              isCalling
                                  ? (isPaused ? 'RESUME' : 'PAUSE')
                                  : 'START NOW',
                              height: h * 0.1),
                          SizedBox(height: w * 0.05),
                          text(context, 'CALLS IN QUEUE', 22,
                              fontWeight: FontWeight.w500,
                              fontfamily: 'Poppins',
                              color: color11,
                              textdecoration: TextDecoration.underline,
                              decorationcolor: color34),
                          SizedBox(height: w * 0.05),
                          // Use a simple container for wrapping ListView
                          Container(
                            height:
                                h * 0.3, // Ensure a fixed height for ListView
                            child: ListView.builder(
                              itemCount: phoneNumbers?.length??0,
                              itemBuilder: (context, index) {
                                final data = phoneNumbers![index];
                                return container(
                                  context,
                                  border: Border.all(color: color35, width: 1),
                                  margin: EdgeInsets.only(bottom: 10),
                                  padding: EdgeInsets.all(5),
                                  borderRadius: BorderRadius.circular(15),
                                  child: Row(
                                    children: [
                                      container(
                                        context,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        colors: color3,
                                        child: Icon(
                                          Icons.call,
                                          size: 18,
                                          color: color11,
                                        ),
                                      ),
                                      SizedBox(
                                        width: w * 0.02,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          text(
                                              context,
                                              (data.name != "")
                                                  ? data.name ?? "Unknown"
                                                  : "Unknown",
                                              18,
                                              fontfamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                              color: color11),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          text(
                                              context, data.number ?? "", 18,
                                              fontfamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                              color: color11),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),
            endDrawer: Drawer(
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: h * 0.14,
                    child: Consumer<UserDetailsProvider>(
                      builder: (context, userDetailsProvider, child) {
                        return DrawerHeader(
                          padding: EdgeInsets.zero,
                          child: Container(
                            // Adjust your container widget here
                            decoration: BoxDecoration(
                              color: color28,
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                  // CircleAvatar with Profile Image
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundColor: Colors.grey,
                                    backgroundImage: userDetailsProvider
                                                .userDetails?.photo !=
                                            null
                                        ? NetworkImage(userDetailsProvider
                                            .userDetails!.photo!)
                                        : AssetImage('assets/personProfile.png')
                                            as ImageProvider,
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02),
                                  // User Details Column
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      text(
                                        context,
                                        userDetailsProvider
                                                .userDetails?.username ??
                                            "Guest User",
                                        18,
                                        fontWeight: FontWeight.w500,
                                        color: color4,
                                        fontfamily: 'Poppins',
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01),
                                      text(
                                        context,
                                        userDetailsProvider
                                                .userDetails?.email ??
                                            "example@domain.com",
                                        18,
                                        fontWeight: FontWeight.w500,
                                        color: color4,
                                        fontfamily: 'Poppins',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Your onTap action here
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16), // Adjust padding as needed
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .start, // Space between the children
                        children: [
                          // Leading Image
                          Image.asset(
                            'assets/phone-call.png',
                            width: w * 0.05,
                            height: h * 0.05,
                          ),
                          SizedBox(
                            width: w * 0.05,
                          ),
                          text(
                              context,
                              'My Calls',
                              fontWeight: FontWeight.w500,
                              fontfamily: 'Poppins',
                              16),
                          Spacer(),
                          Icon(Icons.keyboard_arrow_down_rounded),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Your onTap action here
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16), // Adjust padding as needed
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .start, // Space between the children
                        children: [
                          // Leading Image
                          Image.asset(
                            'assets/at-sign.png',
                            width: w * 0.05,
                            height: h * 0.05,
                          ),
                          SizedBox(
                            width: w * 0.05,
                          ),
                          text(
                              context,
                              'Campaigns',
                              fontWeight: FontWeight.w500,
                              fontfamily: 'Poppins',
                              16),
                          Spacer(),
                          Icon(Icons.keyboard_arrow_down_rounded),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Your onTap action here
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16), // Adjust padding as needed
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .start, // Space between the children
                        children: [
                          // Leading Image
                          Image.asset(
                            'assets/add.png',
                            width: w * 0.05,
                            height: h * 0.05,
                          ),
                          SizedBox(
                            width: w * 0.05,
                          ),
                          text(
                              context,
                              'Leads/Filters',
                              fontWeight: FontWeight.w500,
                              fontfamily: 'Poppins',
                              16),
                          Spacer(),
                          Icon(Icons.keyboard_arrow_down_rounded),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Your onTap action here
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16), // Adjust padding as needed
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .start, // Space between the children
                        children: [
                          // Leading Image
                          Image.asset(
                            'assets/call.png',
                            width: w * 0.05,
                            height: h * 0.05,
                          ),
                          SizedBox(
                            width: w * 0.05,
                          ),
                          text(
                              context,
                              'Call Trackings',
                              fontWeight: FontWeight.w500,
                              fontfamily: 'Poppins',
                              16),
                          Spacer(),
                          Icon(Icons.keyboard_arrow_down_rounded),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Your onTap action here
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16), // Adjust padding as needed
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .start, // Space between the children
                        children: [
                          // Leading Image
                          Image.asset(
                            'assets/message-square.png',
                            width: w * 0.05,
                            height: h * 0.05,
                          ),
                          SizedBox(
                            width: w * 0.05,
                          ),
                          text(
                              context,
                              'Message Templates',
                              fontWeight: FontWeight.w500,
                              fontfamily: 'Poppins',
                              16),
                          Spacer(),
                          Icon(Icons.keyboard_arrow_down_rounded),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Your onTap action here
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16), // Adjust padding as needed
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .start, // Space between the children
                        children: [
                          // Leading Image
                          Image.asset(
                            'assets/tag.png',
                            width: w * 0.05,
                            height: h * 0.05,
                          ),
                          SizedBox(
                            width: w * 0.05,
                          ),
                          text(
                              context,
                              'Labels',
                              fontWeight: FontWeight.w500,
                              fontfamily: 'Poppins',
                              16),
                          Spacer(),
                          Icon(Icons.keyboard_arrow_down_rounded),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Your onTap action here
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16), // Adjust padding as needed
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .start, // Space between the children
                        children: [
                          // Leading Image
                          Image.asset(
                            'assets/settings.png',
                            width: w * 0.05,
                            height: h * 0.05,
                          ),
                          SizedBox(
                            width: w * 0.05,
                          ),
                          text(
                              context,
                              'Settings',
                              fontWeight: FontWeight.w500,
                              fontfamily: 'Poppins',
                              16),
                          Spacer(),
                          Icon(Icons.keyboard_arrow_down_rounded),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          )
        : NoInternetWidget();
  }
}
