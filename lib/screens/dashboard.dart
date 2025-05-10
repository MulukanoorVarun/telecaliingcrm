import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telecaliingcrm/utils/ColorConstants.dart';
import '../bloc/internet_status/internet_status_bloc.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
    return BlocListener<InternetStatusBloc, InternetStatusState>(
      listener: (context, state) {
        if (state is InternetStatusLostState) {
          context.push('/no_internet');
        } else if (state is InternetStatusBackState) {
          context.pop();
        }
      },
      child: Scaffold(
          body: Container(
            color: Colors.transparent,
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                Homescreen(),
                Callhistoryscreen(type: '',),
                LeaderboardScreen(),
              ],
            ),
          ),
          bottomNavigationBar: CurvedNavigationBar(
            key: _bottomNavigationKey,
            animationDuration: const Duration(milliseconds: 100),
            color: color28,
            buttonBackgroundColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            index: _selectedIndex,
            items: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _selectedIndex == 0
                      ? primaryColor
                      : Colors.transparent, // Color when selected
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
                  color: _selectedIndex == 1
                      ? primaryColor
                      : Colors.transparent, // Color when selected
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
                  color: _selectedIndex == 2
                      ? primaryColor
                      : Colors.transparent, // Color when selected
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
          )),
    );
  }
}
