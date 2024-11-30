import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

    return Scaffold(
      body:  PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        animationDuration: Duration(seconds: 2),

        backgroundColor: color4,
        color: color11.withOpacity(0.1),
        buttonBackgroundColor: color3,
        index:_selectedIndex,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.call, size: 30),
          Icon(Icons.leaderboard, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          //Handle button tap
        },
      ),
    );
  }
}
