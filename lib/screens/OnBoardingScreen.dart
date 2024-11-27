import 'package:flutter/material.dart';
import 'package:telecaliingcrm/Authentication/SignInScreen.dart';
import 'package:telecaliingcrm/utils/constants.dart';

class OnBoardindScreen extends StatefulWidget {
  const OnBoardindScreen({super.key});

  @override
  State<OnBoardindScreen> createState() => _OnBoardindScreenState();
}

class _OnBoardindScreenState extends State<OnBoardindScreen> {
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
          InkResponse(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInScreen()));
              },
              child: containertext(context, 'NEXT', width: w * 0.3)),
        ],
      ),
    );
  }
}
