import 'package:flutter/material.dart';
import 'package:telecaliingcrm/utils/CustomAppBar.dart';
import 'package:telecaliingcrm/utils/constants.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: color36,
      appBar: CustomAppBar2(title: 'MyAccount', w: w),
      body: Column(
        children: [
          container(context,w: w,
              h: h*0.85,
              colors:color4,child:InkWell(
              onTap: () {
                // Your onTap action here
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: 10, horizontal: 16), // Adjust padding as needed
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.start, // Space between the children
                  children: [
                    // Leading Image
                    Image.asset(
                      'assets/add.png',
                      width: w * 0.05,
                      height: h * 0.05,
                    ),
                    SizedBox(
                      width: w * 0.05,
                    ),
                    text(
                        context,
                        'Leads/Filters',
                        fontWeight: FontWeight.w500,
                        fontfamily: 'Poppins',
                        16),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_down_rounded),
                  ],
                ),
              ),
            ),)
        ],
      ),
    );
  }
}
