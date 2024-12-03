import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telecaliingcrm/utils/ColorConstants.dart';

import '../Services/otherservices.dart';
import '../providers/ConnectivityProviders.dart';
import '../utils/constants.dart';
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
  final List<Widget> _pages = [
    Homescreen(),
    // CallScreen(),
    LeaderboardScreen(),
  ];

  @override
  void initState() {
    Provider.of<ConnectivityProviders>(context, listen: false)
        .initConnectivity();
    super.initState();
  }
  @override
  void dispose() {
    Provider.of<ConnectivityProviders>(context, listen: false).dispose();
    super.dispose();
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
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: _pages,
        ),
      ),
      bottomNavigationBar:
      CurvedNavigationBar(
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
