import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telecaliingcrm/Authentication/SignInScreen.dart';
import 'package:telecaliingcrm/providers/DashBoardProvider.dart';
import 'package:telecaliingcrm/providers/UserDetailsProvider.dart';
import 'package:telecaliingcrm/screens/FollowupsScreen.dart';
import 'package:telecaliingcrm/screens/LeadsScreen.dart';
import 'package:telecaliingcrm/utils/constants.dart';

import '../providers/ConnectivityProviders.dart';
import '../services/otherservices.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _page = 0;
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


  @override
  void initState() {
    GetDashBoardDetails();
    Provider.of<ConnectivityProviders>(context,listen: false).initConnectivity();

    super.initState();
  }

  @override
  void dispose() {
    Provider.of<ConnectivityProviders>(context, listen: false).dispose();
    super.dispose();
  }

  Future<void> GetDashBoardDetails() async {
    final categories_list_provider =
    Provider.of<DashboardProvider>(context, listen: false);
    categories_list_provider.fetchDashBoardDetails();
  }


  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    var connectiVityStatus =Provider.of<ConnectivityProviders>(context);
    return (connectiVityStatus.isDeviceConnected == "ConnectivityResult.wifi" ||
        connectiVityStatus.isDeviceConnected == "ConnectivityResult.mobile")
        ?
     Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80), // Set the desired height of the AppBar
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent, // Make the AppBar background transparent
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
                InkResponse(onTap: () async {
                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences.remove('token');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignInScreen()),
                  );
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
        ),
      ),

      body:
      Consumer<DashboardProvider>(
        builder: (context, dashboardProvider, child) {
          final PhoneNumbers = dashboardProvider.phoneNumbers;
         return SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
                                text(context, dashboardProvider.todayCalls.toString(), 46,
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
                                text(context,dashboardProvider.pendingCalls.toString(), 46,
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
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => LeadScreen(),));
                            },
                            child: container(
                              w: w * 0.44,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              context,
                              colors: color33,
                              child: Column(
                                children: [
                                  text(context,dashboardProvider.leadCount.toString(), 46,
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
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => FollowupsScreen(),));
                            },
                            child: container(
                              w: w * 0.44,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              context,
                              colors: color30,
                              child: Column(
                                children: [
                                  text(context,dashboardProvider.followup_count.toString(), 46,
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
                      containertext(
                          context,
                          color: color28,
                          width: w * 0.4,
                          'START NOW',
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
                        height: h * 0.3, // Ensure a fixed height for ListView
                        child: ListView.builder(
                          itemCount: PhoneNumbers?.length,
                          itemBuilder: (context, index) {
                            final data= PhoneNumbers?[index];
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
                                    borderRadius: BorderRadius.circular(100),
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      text(context,(data?.name!="")? data?.name??"Unknown" :"Unknown", 18,
                                          fontfamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          color: color11),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      text(context, data?.number??"", 18,
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
            SizedBox(height: h*0.14,
              child:
              Consumer<UserDetailsProvider>(
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
                              backgroundImage: userDetailsProvider.userDetails?.photo != null
                                  ? NetworkImage(userDetailsProvider.userDetails!.photo!)
                                  : AssetImage('assets/personProfile.png') as ImageProvider,
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                            // User Details Column
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                text(
                                  context,
                                  userDetailsProvider.userDetails?.username ?? "Guest User",
                                  18,
                                  fontWeight: FontWeight.w500,
                                  color: color4,
                                  fontfamily: 'Poppins',
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                text(
                                  context,
                                  userDetailsProvider.userDetails?.email ?? "example@domain.com",
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
                    vertical: 10, horizontal: 16), // Adjust padding as needed
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.start, // Space between the children
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
                    vertical: 10, horizontal: 16), // Adjust padding as needed
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.start, // Space between the children
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
                    vertical: 10, horizontal: 16), // Adjust padding as needed
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.start, // Space between the children
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
                    vertical: 10, horizontal: 16), // Adjust padding as needed
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.start, // Space between the children
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
                    vertical: 10, horizontal: 16), // Adjust padding as needed
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.start, // Space between the children
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
                    vertical: 10, horizontal: 16), // Adjust padding as needed
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.start, // Space between the children
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
            ),InkWell(
              onTap: () {
                // Your onTap action here
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: 10, horizontal: 16), // Adjust padding as needed
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.start, // Space between the children
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
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        backgroundColor: color4,
        color: color11.withOpacity(0.1),
        buttonBackgroundColor: color3,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.call, size: 30),
          Icon(Icons.leaderboard, size: 30),
        ],
        onTap: (index) {
          //Handle button tap
        },
      ),
    ): NoInternetWidget();
  }
}
