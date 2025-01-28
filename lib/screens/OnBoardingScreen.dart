import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telecaliingcrm/Authentication/SignInScreen.dart';
import 'package:telecaliingcrm/utils/constants.dart';
import 'package:telecaliingcrm/utils/preferences.dart';

class OnBoardindScreen extends StatefulWidget {
  const OnBoardindScreen({super.key});

  @override
  State<OnBoardindScreen> createState() => _OnBoardindScreenState();
}

class _OnBoardindScreenState extends State<OnBoardindScreen> {

  @override
  void initState() {
    PreferenceService().saveString("onboard_status","1");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/onboarding.png',
              fit: BoxFit.contain,
              width: w * 0.6,
              height: h * 0.3,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          text(
              context,
              'Efficiency Meets Effectiveness  Revolutionize Your Telecalling Operations',
              18,
              fontfamily: 'Poppins',
              color: color11,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w500),
          SizedBox(
            height: h * 0.2,
          ),
          containertext(context, 'NEXT', width: w * 0.9,color:Color(0xff7165E3),onTap: (){
            Navigator.of(context).pushReplacement(
                PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
                return SignInScreen();
              },
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                var tween = Tween(
                    begin: begin, end: end)
                    .chain(CurveTween(
                    curve: curve));
                var offsetAnimation =
                animation.drive(tween);
                return SlideTransition(
                    position: offsetAnimation,
                    child: child);
              },
            ));
          }),
        ],
      ),
    );
  }
}
