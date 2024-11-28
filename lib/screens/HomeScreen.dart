import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telecaliingcrm/utils/constants.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _page = 0;
  File? _image; // To store the selected image
  bool isLoading = false; // Loading state
  XFile? _pickedFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, // Use ImageSource.camera for camera
      imageQuality: 100,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Set the selected image file
        print("Image: ${_image?.path}"); // Print the image path for debugging
      });
    } else {
      print("No image selected.");
    }
  }

  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
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
                  InkResponse(
                    onTap: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
                    child: Icon(
                      Icons.menu,
                      size: 26,
                      color: color11,
                    ),
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
                        w: w * 0.4,
                        context,
                        colors: color31,
                        child: Column(
                          children: [
                            text(context, '302', 46,
                                fontfamily: 'Poppins',
                                fontWeight: FontWeight.w500),
                            text(context, 'Todays Calls', 14,
                                fontfamily: 'Inter',
                                fontWeight: FontWeight.w500),
                          ],
                        ),
                      ),
                      Spacer(),
                      container(
                        w: w * 0.4,
                        context,
                        colors: color32,
                        child: Column(
                          children: [
                            text(context, '300', 46,
                                fontfamily: 'Poppins',
                                fontWeight: FontWeight.w500),
                            text(context, 'Pending Calls', 14,
                                fontfamily: 'Inter',
                                fontWeight: FontWeight.w500),
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
                        w: w * 0.4,
                        context,
                        colors: color33,
                        child: Column(
                          children: [
                            text(context, '302', 46,
                                fontfamily: 'Poppins',
                                fontWeight: FontWeight.w500),
                            text(context, 'Leads', 14,
                                fontfamily: 'Inter',
                                fontWeight: FontWeight.w500),
                          ],
                        ),
                      ),
                      Spacer(),
                      container(
                        w: w * 0.4,
                        context,
                        colors: color30,
                        child: Column(
                          children: [
                            text(context, '300', 46,
                                fontfamily: 'Poppins',
                                fontWeight: FontWeight.w500),
                            text(context, 'Follow Ups', 14,
                                fontfamily: 'Inter',
                                fontWeight: FontWeight.w500),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.06),
                  containertext(
                      context,
                      color: color28,
                      width: w * 0.4,
                      'START NOW',
                      height: h * 0.1),
                  SizedBox(
                    height: h * 0.04,
                  ),
                  text(context, 'CALLS IN QUEUE', 24,
                      fontWeight: FontWeight.w500,
                      fontfamily: 'Poppins',
                      color: color11,
                      textdecoration: TextDecoration.underline,
                      decorationcolor: color34),
                  SizedBox(
                    height: h * 0.02,
                  ),
                  // Use a simple container for wrapping ListView
                  Container(
                    height: h * 0.3, // Ensure a fixed height for ListView
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return container(
                          context,
                          border: Border.all(color: color35, width: 1),
                          borderRadius: BorderRadius.circular(15),
                          child: Row(
                            children: [
                              container(
                                context,
                                borderRadius: BorderRadius.circular(100),
                                colors: color3,
                                child: Icon(
                                  Icons.call,
                                  size: 18,
                                  color: color11,
                                ),
                              ),
                              SizedBox(
                                width: w * 0.02,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  text(context, 'name', 18,
                                      fontfamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      color: color11),
                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                  text(context, '1234567890', 18,
                                      fontfamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      color: color11),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.all(0),
              child: SizedBox(
                height: h * 0.1,
                child: container(
                  context,
                  colors: color28,
                  margin: EdgeInsets.all(0),
                  borderRadius: BorderRadius.circular(0),
                  child: Center(
                    child: Row(children: [
                      Center(
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.grey,
                                  // backgroundImage:_image != null
                                  //     ? FileImage(_image!) as ImageProvider<Object>:
                                  // profile_image != null && profile_image.isNotEmpty
                                  //     ? NetworkImage(profile_image) as ImageProvider<Object>
                                  //     : AssetImage('assets/personProfile.png') as ImageProvider<Object>, // Fallback if no image is available
                                ),


                              ],
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: _pickImage,
                                child: const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Color(0xFFCAA16C1A),
                                    size: 20, // Size of the camera icon
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: w * 0.02,
                      ),

                      Column(mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text(context, 'name', 18,
                              fontWeight: FontWeight.w500,
                              fontfamily: 'Poppins'),
                          SizedBox(
                            height: h * 0.02,
                          ),
                          text(context, '123456789', 18,
                              fontWeight: FontWeight.w500,
                              fontfamily: 'Poppins'),
                        ],
                      )
                    ]),
                  ),

                ),
              ),
            ),
            ListTile(
              title: Text('Option 1'),
              onTap: () {
                // Handle option 1
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Option 2'),
              onTap: () {
                // Handle option 2
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        backgroundColor: color4,
        color: color11.withOpacity(0.1),
        buttonBackgroundColor: color3,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.call, size: 30),
          Icon(Icons.leaderboard, size: 30),
        ],
        onTap: (index) {
          //Handle button tap
        },
      ),
    );
  }
}
