import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telecaliingcrm/Authentication/SignInScreen.dart';
import 'package:telecaliingcrm/screens/PermissionScreen.dart';
import 'package:telecaliingcrm/utils/ColorConstants.dart';
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
    PreferenceService().saveString("onboard_status", "1");
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
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: text(
                context,
                'Efficiency Meets Effectiveness Revolutionize Your Telecalling Operations',
                18,
                fontfamily: 'Poppins',
                color: color11,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: h * 0.2,
          ),
          containertext(context, 'NEXT',
              color: Color(0xff7165E3), width: w * 0.9, onTap: () {
            context.pushReplacement("/permission");
          }),
        ],
      ),
    );
  }
}
