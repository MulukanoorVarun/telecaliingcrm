import 'dart:async';
import 'dart:io';

import 'package:call_log/call_log.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state/phone_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telecaliingcrm/Authentication/SignInScreen.dart';
import 'package:telecaliingcrm/Services/UserApi.dart';
import 'package:telecaliingcrm/providers/DashBoardProvider.dart';
import 'package:telecaliingcrm/providers/UserDetailsProvider.dart';
import 'package:telecaliingcrm/screens/Edit%20Profile%20screeen.dart';
import 'package:telecaliingcrm/screens/FollowupsScreen.dart';
import 'package:telecaliingcrm/screens/LeadsScreen.dart';
import 'package:telecaliingcrm/utils/ColorConstants.dart';
import 'package:telecaliingcrm/utils/constants.dart';

import '../model/DashBoardModel.dart';
import '../providers/ConnectivityProviders.dart';
import '../services/Shimmers.dart';
import '../services/otherservices.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
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
    final user_details_provider =
        Provider.of<UserDetailsProvider>(context, listen: false);
    dashboard_provider.fetchDashBoardDetails();
    user_details_provider.fetchUserDetails();
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
        return timestampB.compareTo(timestampA);
      });

    for (CallLogEntry log in sortedLogs) {
      if (log.number == lastDialedNumber && log.duration != null) {
        _onCallEnd(
            log.duration!, log.number!, phoneNumbers![currentIndex - 1].id!);
        break;
      }
    }
  }

  // Handle call end, update call duration, and show dialog
  void _onCallEnd(int duration, String number, int id) {
    setState(() {
      callDuration = duration;
      mobile_nnumber = number;
    });

    _showCallDurationDialog(mobile_nnumber, id);

    // After showing the dialog, remove the number from the list
    setState(() {
      phoneNumbers!.removeAt(currentIndex - 1); // Remove the last dialed number
      currentIndex =
          currentIndex > 0 ? currentIndex - 1 : 0; // Correct the index
    });
  }

  void _showCallDurationDialog(mobile_nnumber, id) {
    String? selectedStatus; // Variable to hold the selected status
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Call Duration",
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
                Text(
                  "Duration: $callDuration seconds",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  "Mobile Number: $mobile_nnumber",
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
                  padding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10), // Button padding
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
                    updateCallStatus(
                        id.toString(), selectedStatus, callDuration.toString());
                  } else {
                    // If no status is selected, show a message or do nothing
                    print("No status selected");
                  }
                },
                child: Text(
                  "Submit",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      fontFamily: "Poppins",
                      color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void updateCallStatus(id, callStatus, String callDuration) async {
    var result =
        await Userapi.UpdateCallStatusApi(id, callStatus, callDuration);
    if (result != null) {
      // Process the result here (e.g., display a message to the user)
      print("Response: $result");
      CustomSnackBar.show(context, "Call Staus Updated Successfully!");
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
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(80), // Set the desired height of the AppBar
              child: Consumer<UserDetailsProvider>(
                  builder: (context, userDetailsProvider, child) {
                return AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  // Make the AppBar background transparent
                  elevation: 0,
                  // Remove the default shadow of the AppBar
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
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          userDetailsProvider
                                      .userDetails?.username?.isNotEmpty ??
                                  false
                              ? userDetailsProvider.userDetails!.username![0]
                                      .toUpperCase() +
                                  userDetailsProvider.userDetails!.username!
                                      .substring(1)
                              : "",
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        // Power icon
                        InkResponse(
                          onTap: () async {
                            _showLogoutDialog(context);
                          },
                          child: Icon(
                            Icons.power_settings_new,
                            size: 26,
                            color: color11,
                          ),
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
                );
              }),
            ),
            body: Consumer<DashboardProvider>(
                builder: (context, dashboardProvider, child) {
              final numbers = dashboardProvider.phoneNumbers;
              phoneNumbers = numbers;
              if (dashboardProvider.isLoading) {
                return SingleChildScrollView(child: _buildShimmerBody());
              } else {
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
                                          dashboardProvider.todayCalls
                                                  .toString() ??
                                              "",
                                          46,
                                          fontfamily: 'Poppins',
                                          fontWeight: FontWeight.w500),
                                      text(context, 'Todays Calls', 18,
                                          fontfamily: 'Poppins',
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
                                                  .toString() ??
                                              "",
                                          46,
                                          fontfamily: 'Poppins',
                                          fontWeight: FontWeight.w500),
                                      text(context, 'Pending Calls', 18,
                                          fontfamily: 'Poppins',
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
                                                    .toString() ??
                                                "",
                                            46,
                                            fontfamily: 'Poppins',
                                            fontWeight: FontWeight.w500),
                                        text(context, 'Leads', 18,
                                            fontfamily: 'Poppins',
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
                                          builder: (context) =>
                                              FollowupsScreen(),
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
                                                    .toString() ??
                                                "",
                                            46,
                                            fontfamily: 'Poppins',
                                            fontWeight: FontWeight.w500),
                                        text(context, 'Follow Ups', 18,
                                            fontfamily: 'Poppins',
                                            fontWeight: FontWeight.w500),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if(phoneNumbers?.length!=0)...[
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
                            text(context, 'CALLS IN QUEUE', 20,
                                fontWeight: FontWeight.w500,
                                fontfamily: 'Poppins',
                                color: color11,
                                textdecoration: TextDecoration.underline,
                                decorationcolor: color34),
                            SizedBox(height: w * 0.05),
                            Container(
                              height:
                                  h * 0.3, // Ensure a fixed height for ListView
                              child: ListView.builder(
                                itemCount: phoneNumbers?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final data = phoneNumbers![index];
                                  return container(
                                    context,
                                    border:
                                        Border.all(color: color35, width: 1),
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
                                            if(data.name== null)...[
                                              Container(width: w*0.6,
                                                child: text(
                                                    context,
                                                    (data.name != "")
                                                        ? data.name ?? "Unknown"
                                                        : "Unknown",
                                                    18,
                                                    fontfamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    textAlign: TextAlign.left,
                                                    overflow: TextOverflow.ellipsis,
                                                    color: color11),
                                              ),
                                            ],
                                            SizedBox(
                                              height: 5,
                                            ),
                                            text(context, data.number ?? "", 18,
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
                            ]else...[
                              Column(
                                children: [
                                  SizedBox(height: w*0.2,),
                                  Lottie.asset(
                                      'assets/animations/nodata1.json', // Your Lottie animation file
                                      width: 150, // Adjust the size as needed
                                      height: 150,
                                      fit: BoxFit.cover,),
                                ],
                              ),
                            ]
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }
            }),
            endDrawer: Drawer(
              shadowColor: Colors.transparent,
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: h * 0.14,
                    child: Consumer<UserDetailsProvider>(
                      builder: (context, userDetailsProvider, child) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          child: Center(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.grey,
                                  child: userDetailsProvider
                                              .userDetails?.photo !=
                                          null
                                      ? ClipOval(
                                          // Ensure the image is clipped into a circle
                                          child: Image.network(
                                            userDetailsProvider
                                                .userDetails!.photo!,
                                            fit: BoxFit.cover,
                                            width:
                                                60, // Ensure it's sized to fit the CircleAvatar
                                            height:
                                                60, // Ensure it's sized to fit the CircleAvatar
                                          ),
                                        )
                                      : userDetailsProvider
                                                  .userDetails?.username !=
                                              null
                                          ? // Show the first character of the user's name if no photo
                                          Text(
                                              userDetailsProvider
                                                  .userDetails!.username![0]
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : // If there's no photo or name, show a fallback image
                                          ClipOval(
                                              // Ensure fallback image is also clipped into a circle
                                              child: Image.asset(
                                                'assets/person.png',
                                                fit: BoxFit.cover,
                                                width:
                                                    60, // Ensure it's sized to fit the CircleAvatar
                                                height:
                                                    60, // Ensure it's sized to fit the CircleAvatar
                                              ),
                                            ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.02),
                                // User Details Column
                                Container(
                                  width: w * 0.4,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userDetailsProvider.userDetails
                                                    ?.username?.isNotEmpty ??
                                                false
                                            ? userDetailsProvider
                                                    .userDetails!.username![0]
                                                    .toUpperCase() +
                                                userDetailsProvider
                                                    .userDetails!.username!
                                                    .substring(1)
                                            : "",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w500,
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.black),
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
                                        color: color11,
                                        overflow: TextOverflow.ellipsis,
                                        fontfamily: 'Poppins',
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                // InkResponse(
                                //     onTap: () {
                                //       Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //               builder: (context) =>
                                //                   EditProfileScreen()));
                                //     },
                                //     child: Icon(
                                //       Icons.edit,
                                //       color: color4,
                                //     ))
                                Container(
                                  padding: EdgeInsets.all(0.0),
                                  decoration: BoxDecoration(
                                    color: primaryColor, // background color of the container
                                    borderRadius:
                                    BorderRadius.circular(
                                        10), // rounded corners
                                  ),
                                  child: IconButton(
                                    visualDensity: VisualDensity.compact,
                                    padding: EdgeInsets.all(0),
                                    icon: Icon(
                                      Icons.edit,
                                      color:
                                      Colors.white, // Icon color
                                    ),
                                    onPressed: () async {
                                      // Action when the edit button is pressed
                                      var res = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>

                                          EditProfileScreen()));
                                      },
                                    tooltip: 'Edit',
                                  ),
                                ),
                                SizedBox(width: 10,),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(color: Colors.grey[300],height: 0.5,),
                  // InkWell(
                  //   onTap: () {
                  //     // Your onTap action here
                  //   },
                  //   child: Container(
                  //     padding: EdgeInsets.symmetric(
                  //         vertical: 10,
                  //         horizontal: 16), // Adjust padding as needed
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment
                  //           .start, // Space between the children
                  //       children: [
                  //         // Leading Image
                  //         Image.asset(
                  //           'assets/phone-call.png',
                  //           width: w * 0.05,
                  //           height: h * 0.05,
                  //         ),
                  //         SizedBox(
                  //           width: w * 0.05,
                  //         ),
                  //         text(
                  //             context,
                  //             'My Calls',
                  //             fontWeight: FontWeight.w500,
                  //             fontfamily: 'Poppins',
                  //             16),
                  //         Spacer(),
                  //         Icon(Icons.keyboard_arrow_down_rounded),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     // Your onTap action here
                  //   },
                  //   child: Container(
                  //     padding: EdgeInsets.symmetric(
                  //         vertical: 10,
                  //         horizontal: 16), // Adjust padding as needed
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment
                  //           .start, // Space between the children
                  //       children: [
                  //         // Leading Image
                  //         Image.asset(
                  //           'assets/at-sign.png',
                  //           width: w * 0.05,
                  //           height: h * 0.05,
                  //         ),
                  //         SizedBox(
                  //           width: w * 0.05,
                  //         ),
                  //         text(
                  //             context,
                  //             'Campaigns',
                  //             fontWeight: FontWeight.w500,
                  //             fontfamily: 'Poppins',
                  //             16),
                  //         Spacer(),
                  //         Icon(Icons.keyboard_arrow_down_rounded),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LeadScreen(),
                          ));
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
                              'Leads',
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
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FollowupsScreen(),
                          ));
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
                              'Follow Ups',
                              fontWeight: FontWeight.w500,
                              fontfamily: 'Poppins',
                              16),
                          Spacer(),
                          Icon(Icons.keyboard_arrow_down_rounded),
                        ],
                      ),
                    ),
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     // Your onTap action here
                  //   },
                  //   child: Container(
                  //     padding: EdgeInsets.symmetric(
                  //         vertical: 10,
                  //         horizontal: 16), // Adjust padding as needed
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment
                  //           .start, // Space between the children
                  //       children: [
                  //         // Leading Image
                  //        Icon(Icons.call_rounded),
                  //         SizedBox(
                  //           width: w * 0.05,
                  //         ),
                  //         text(
                  //             context,
                  //             'Call Trackings',
                  //             fontWeight: FontWeight.w500,
                  //             fontfamily: 'Poppins',
                  //             16),
                  //         Spacer(),
                  //         Icon(Icons.keyboard_arrow_down_rounded),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     // Your onTap action here
                  //   },
                  //   child: Container(
                  //     padding: EdgeInsets.symmetric(
                  //         vertical: 10,
                  //         horizontal: 16), // Adjust padding as needed
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment
                  //           .start, // Space between the children
                  //       children: [
                  //         // Leading Image
                  //         Image.asset(
                  //           'assets/message-square.png',
                  //           width: w * 0.05,
                  //           height: h * 0.05,
                  //         ),
                  //         SizedBox(
                  //           width: w * 0.05,
                  //         ),
                  //         text(
                  //             context,
                  //             'Message Templates',
                  //             fontWeight: FontWeight.w500,
                  //             fontfamily: 'Poppins',
                  //             16),
                  //         Spacer(),
                  //         Icon(Icons.keyboard_arrow_down_rounded),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     // Your onTap action here
                  //   },
                  //   child: Container(
                  //     padding: EdgeInsets.symmetric(
                  //         vertical: 10,
                  //         horizontal: 16), // Adjust padding as needed
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment
                  //           .start, // Space between the children
                  //       children: [
                  //         // Leading Image
                  //         Image.asset(
                  //           'assets/tag.png',
                  //           width: w * 0.05,
                  //           height: h * 0.05,
                  //         ),
                  //         SizedBox(
                  //           width: w * 0.05,
                  //         ),
                  //         text(
                  //             context,
                  //             'Labels',
                  //             fontWeight: FontWeight.w500,
                  //             fontfamily: 'Poppins',
                  //             16),
                  //         Spacer(),
                  //         Icon(Icons.keyboard_arrow_down_rounded),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     // Your onTap action here
                  //   },
                  //   child: Container(
                  //     padding: EdgeInsets.symmetric(
                  //         vertical: 10,
                  //         horizontal: 16), // Adjust padding as needed
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment
                  //           .start, // Space between the children
                  //       children: [
                  //         // Leading Image
                  //         Image.asset(
                  //           'assets/settings.png',
                  //           width: w * 0.05,
                  //           height: h * 0.05,
                  //         ),
                  //         SizedBox(
                  //           width: w * 0.05,
                  //         ),
                  //         text(
                  //             context,
                  //             'Settings',
                  //             fontWeight: FontWeight.w500,
                  //             fontfamily: 'Poppins',
                  //             16),
                  //         Spacer(),
                  //         Icon(Icons.keyboard_arrow_down_rounded),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          )
        : NoInternetWidget();
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout Confirmation'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkResponse(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                        color: color28,
                        borderRadius: BorderRadius.circular(10)),
                    child: text(context, 'Cancel', 14,
                        fontfamily: 'Inter', color: color4),
                  ),
                ),
                InkResponse(
                  onTap: () async {
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    sharedPreferences.remove('token');

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: primaryColor)),
                    child: text(context, 'Logout', 14,
                        fontfamily: 'Inter', color: primaryColor),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildShimmerBody() {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  shimmerContainer(160, 100), // Shimmer for first container
                  shimmerContainer(160, 100), // Shimmer for second container
                ],
              ),
              SizedBox(height: h * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  shimmerContainer(160, 100), // Shimmer for first container
                  shimmerContainer(160, 100),
                ],
              ),
              SizedBox(height: w * 0.07),
              shimmerContainer(150, 50, isButton: true), // Shimmer button
              SizedBox(height: w * 0.05),
              shimmerText(150, 20), // Shimmer title
              SizedBox(height: w * 0.05),
              _buildShimmerList(), // Shimmer for list of phone numbers
            ],
          ),
        ),
      ],
    );
  }

  // Shimmer effect for the list of phone numbers
  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 10, // Number of shimmer items
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Row(
            children: [
              shimmerCircle(40), // Shimmer for circular image
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmerText(100, 15), // Shimmer for name
                  SizedBox(height: 5),
                  shimmerText(150, 15), // Shimmer for phone number
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
