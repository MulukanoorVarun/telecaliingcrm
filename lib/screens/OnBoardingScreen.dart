import 'package:flutter/material.dart';

class OnBoardindScreen extends StatefulWidget {
  const OnBoardindScreen({super.key});

  @override
  State<OnBoardindScreen> createState() => _OnBoardindScreenState();
}

class _OnBoardindScreenState extends State<OnBoardindScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Center(child: Image.asset('assets/onboarding.png',fit: BoxFit.contain,),),

    );
  }
}
