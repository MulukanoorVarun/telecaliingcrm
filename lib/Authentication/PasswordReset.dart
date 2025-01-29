import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telecaliingcrm/Authentication/SetNewPassword.dart';
import 'package:telecaliingcrm/Services/otherservices.dart';
import 'package:telecaliingcrm/providers/ConnectivityProviders.dart';

import '../utils/constants.dart';

class Passwordreset extends StatefulWidget {
  final String email;
  const Passwordreset({super.key,required this.email});

  @override
  State<Passwordreset> createState() => _PasswordresetState();
}

class _PasswordresetState extends State<Passwordreset> {
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
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    var connectiVityStatus = Provider.of<ConnectivityProviders>(context);
    return (connectiVityStatus.isDeviceConnected == "ConnectivityResult.wifi" ||
        connectiVityStatus.isDeviceConnected == "ConnectivityResult.mobile")
        ? Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 30),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: color4,
              borderRadius: BorderRadius.all(Radius.circular(8))
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Icon(Icons.arrow_back),
                  SizedBox(
                    width: 15,
                  ),
                  text(context, 'PASSWORD RESET', 18,
                      color: color11,
                      fontfamily: "Inter",
                      fontWeight: FontWeight.w700),
                ],
              ),
              SizedBox(
                height: h*0.3,
              ),
              text(context, 'Your password has been successfully reset. click confirm to set a new password', 20,
                  color: color,
                  fontWeight: FontWeight.w500,
                  fontfamily: "Poppins"),
              SizedBox(
                height: h*0.28,
              ),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SetnewpasswordScreen(email: widget.email,),));
                },
                child: Center(
                  child: Container(
                    width: w,
                    height: 60,
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8),
                        ),

                    ),
                    child: Center(
                      child: text(context, 'CONFIRM', 16,
                          color: color4,
                          fontfamily: "Inter",
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    ): NoInternetWidget();
  }
}
