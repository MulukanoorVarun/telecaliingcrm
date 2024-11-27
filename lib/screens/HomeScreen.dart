import 'package:flutter/material.dart';
import 'package:telecaliingcrm/utils/constants.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xffffffff), // White color for the container
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(0, 4),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/telecalling_appicon.webp',
                  fit: BoxFit.contain,
                  width: w * 0.14,
                ),
                Spacer(),
                container(context,
                    padding: EdgeInsets.all(8),
                    colors: color30,
                    child: text(context, 'HI! Ramakrishnamurthy', 16)),
                Spacer(),
                Icon(
                  Icons.power_settings_new,
                  size: 26,
                  color: color11,
                ),
                SizedBox(
                  width: 18,
                ),
                Icon(
                  Icons.menu,
                  size: 26,
                  color: color11,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    container(
                      w: w * 0.43,
                      context,
                      colors: color31,
                      child: Column(
                        children: [
                          text(context, '302', 46,
                              fontfamily: 'Poppins',
                              fontWeight: FontWeight.w500),
                          text(context, 'Todays Calls', 14,
                              fontfamily: 'Inter', fontWeight: FontWeight.w500),
                        ],
                      ),
                    ),
                    Spacer(),
                    container(
                      w: w * 0.43,
                      context,
                      colors: color32,
                      child: Column(
                        children: [
                          text(context, '300', 46,
                              fontfamily: 'Poppins',
                              fontWeight: FontWeight.w500),
                          text(context, 'Pending Calls', 14,
                              fontfamily: 'Inter', fontWeight: FontWeight.w500),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: h * 0.02,
                ),
                Row(
                  children: [
                    container(
                      w: w * 0.43,
                      context,
                      colors: color33,
                      child: Column(
                        children: [
                          text(context, '302', 46,
                              fontfamily: 'Poppins',
                              fontWeight: FontWeight.w500),
                          text(context, 'Leads', 14,
                              fontfamily: 'Inter', fontWeight: FontWeight.w500),
                        ],
                      ),
                    ),
                    Spacer(),
                    container(
                      w: w * 0.43,
                      context,
                      colors: color30,
                      child: Column(
                        children: [
                          text(context, '300', 46,
                              fontfamily: 'Poppins',
                              fontWeight: FontWeight.w500),
                          text(context, 'Follow Ups', 14,
                              fontfamily: 'Inter', fontWeight: FontWeight.w500),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: h*0.06),
                containertext(context, color: color28,width: w*0.4,'START NOW',height: h*0.1),
                SizedBox(height: h*0.1,),

              ],
            ),
          )
        ],
      ),
    );
  }
}
