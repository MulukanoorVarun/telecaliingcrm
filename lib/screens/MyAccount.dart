import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telecaliingcrm/utils/CustomAppBar.dart';
import 'package:telecaliingcrm/utils/constants.dart';

import '../providers/ConnectivityProviders.dart';
import '../services/otherservices.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  void initState() {
    Provider.of<ConnectivityProviders>(context,listen: false).initConnectivity();
    super.initState();
  }

  @override
  void dispose() {
    Provider.of<ConnectivityProviders>(context, listen: false).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    var connectiVityStatus =Provider.of<ConnectivityProviders>(context);
    return (connectiVityStatus.isDeviceConnected == "ConnectivityResult.wifi" ||
        connectiVityStatus.isDeviceConnected == "ConnectivityResult.mobile")
        ? Scaffold(
      backgroundColor: color36,
      appBar: CustomAppBar2(title: 'MyAccount', w: w),
      body: Column(
        children: [
          container(
            context,
            w: w,
            h: h * 0.85,
            colors: color4,
            child: Column(
              children: [
                Center(
                  child:
                  Column(
                    children: [
                      Stack(children: [ClipRRect(
                          child: Image.asset(
                            'assets/person.png',
                            width: w * 0.2,
                            height: h*0.2,
                            fit: BoxFit.contain,
                          )),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: (){

                            },
                            child: const CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.camera_alt,
                                color: Color(0xFFCAA16C1A),
                                size: 18, // Size of the camera icon
                              ),
                            ),
                          ),
                        ),],

                      ),
                      text(context, 'Charan', 25,fontfamily: 'Poppins',fontWeight: FontWeight.w600)
                    ],
                  ),

                ),
                InkWell(
                  onTap: () {
                    // Your onTap action here
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16), // Adjust padding as needed
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.start, // Space between the children
                      children: [
                        // Leading Image
                        Image.asset(
                          'assets/lock_reset_24.png',
                          width: w * 0.05,
                          height: h * 0.05,
                          color: color28,
                        ),
                        SizedBox(
                          width: w * 0.05,
                        ),
                        text(
                            context,
                            'Change Password',
                            fontWeight: FontWeight.w500,
                            fontfamily: 'Poppins',
                            16),
                        Spacer(),
                        Icon(Icons.keyboard_arrow_down_rounded),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Your onTap action here
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16), // Adjust padding as needed
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.start, // Space between the children
                      children: [
                        // Leading Image
                        Image.asset(
                          'assets/report.png',
                          width: w * 0.05,
                          height: h * 0.05,
                          color: color28,
                        ),
                        SizedBox(
                          width: w * 0.05,
                        ),
                        text(
                            context,
                            'My Reports ',
                            fontWeight: FontWeight.w500,
                            fontfamily: 'Poppins',
                            16),
                        Spacer(),
                        Icon(Icons.keyboard_arrow_down_rounded),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Your onTap action here
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16), // Adjust padding as needed
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.start, // Space between the children
                      children: [
                        // Leading Image
                        Image.asset(
                          'assets/logout.png',
                          width: w * 0.05,
                          height: h * 0.05,
                          color: color28,
                        ),
                        SizedBox(
                          width: w * 0.05,
                        ),
                        text(
                            context,
                            'Logout',
                            fontWeight: FontWeight.w500,
                            fontfamily: 'Poppins',
                            16),
                        Spacer(),
                        Icon(Icons.keyboard_arrow_down_rounded),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ): NoInternetWidget();
  }
}
