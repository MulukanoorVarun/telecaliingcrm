import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:telecaliingcrm/screens/LeadInformation.dart';
import 'package:telecaliingcrm/screens/LeadsScreen.dart';
import 'package:telecaliingcrm/utils/preferences.dart';

import '../utils/ColorConstants.dart';
import 'AddLeadsScreen.dart';
import 'HomeScreen.dart';
import 'LeaderBoardScreen.dart';
import 'OnBoardingScreen.dart';
import 'UpdatePasswordScreen.dart';


class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  String token="";
  String status="";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    // Navigate to the next screen after the animation
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 3), () async {
        if(token!=""){

        }else{
          Navigator.push(context, MaterialPageRoute(builder: (context) => OnBoardindScreen()));
        }
      });
    });
    Fetchdetails();
  }


  Fetchdetails() async {
    var Token = (await PreferenceService().getString('token'))??"";
    setState(() {
      token=Token;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: Image.asset(
              "assets/telecalling_splash.png",
              width: 240,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }
}
