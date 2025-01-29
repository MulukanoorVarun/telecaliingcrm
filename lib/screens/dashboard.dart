import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:telecaliingcrm/utils/ColorConstants.dart';

import '../Services/otherservices.dart';
import '../providers/ConnectivityProviders.dart';
import '../utils/constants.dart';
import 'CallHistoryScreen.dart';
import 'HomeScreen.dart';
import 'LeaderBoardScreen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    Provider.of<ConnectivityProviders>(context, listen: false)
        .initConnectivity();
    // Using addPostFrameCallback to delay the request until the widget is fully built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestPhonePermissions(context); // Now context will work.
    });
    super.initState();
  }
  @override
  void dispose() {
    Provider.of<ConnectivityProviders>(context, listen: false).dispose();
    super.dispose();
  }

  static Future<bool> requestPhonePermissions(BuildContext context) async {
    // Initial permission request
    Map<Permission, PermissionStatus> statuses = await [
      Permission.phone,
      Permission.contacts,  // For contacts access
    ].request();

    bool phoneGranted = statuses[Permission.phone]?.isGranted ?? false;
    bool callLogGranted = statuses[Permission.contacts]?.isGranted ?? false;

    if (phoneGranted && callLogGranted) {
      return true; // Permissions granted on first request
    }

    // If not granted, ask again for permission
    Map<Permission, PermissionStatus> reStatuses = await [
      Permission.phone,
      Permission.contacts,
    ].request();

    bool rePhoneGranted = reStatuses[Permission.phone]?.isGranted ?? false;
    bool reCallLogGranted = reStatuses[Permission.contacts]?.isGranted ?? false;

    if (rePhoneGranted && reCallLogGranted) {
      return true; // Permissions granted on second request
    }

    // Permissions still not granted, show the dialog asking user to open settings
    _showPermissionDialog(
      context,
      "Permission Required",
      "You need to enable Phone & Call Log permissions to access. Please go to Settings > Apps > Telecalling CRM > Permissions.",
      openSettings: true,
    );
    return false;
  }

  static void _showPermissionDialog(
      BuildContext context, String title, String message, {required bool openSettings}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title,style: TextStyle(fontFamily: "Inter"),),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () async {
                if (openSettings) {
                  await openAppSettings(); // Opens app settings
                }
                Navigator.pop(context);
              },
              child: Text(openSettings ? "Open Settings" : "Cancel",
                  style: TextStyle(color: primaryColor,fontFamily: "Inter")),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
    var connectiVityStatus = Provider.of<ConnectivityProviders>(context);
    return (connectiVityStatus.isDeviceConnected == "ConnectivityResult.wifi" ||
        connectiVityStatus.isDeviceConnected == "ConnectivityResult.mobile")
        ?  Scaffold(
      body: Container(
        color: Colors.transparent,
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            Homescreen(),
            Callhistoryscreen(type:'' ,date: '',),
            LeaderboardScreen(),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        animationDuration: const Duration(milliseconds: 200),
        color: color28,
        buttonBackgroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        index: _selectedIndex,
        items: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _selectedIndex == 0 ? primaryColor : Colors.transparent, // Color when selected
            ),
            child: Icon(
              Icons.home,
              size: 30,
              color: Colors.white,
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _selectedIndex == 1 ? primaryColor : Colors.transparent, // Color when selected
            ),
            child: Icon(
              Icons.call,
              size: 30,
              color: Colors.white,
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _selectedIndex == 2 ? primaryColor : Colors.transparent, // Color when selected
            ),
            child: Icon(
              Icons.leaderboard,
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _pageController.jumpToPage(index);
        },
      )
    ): NoInternetWidget();
  }
}
