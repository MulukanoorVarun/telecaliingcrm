import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/ConnectivityProviders.dart';
import '../providers/UserDetailsProvider.dart';

import '../utils/ColorConstants.dart';
import '../utils/ShakeWidget.dart';
import 'dart:async';
import '../Services/otherservices.dart';
import '../utils/constants.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final FocusNode _focusNodeFullName = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();
  File? _image; // To store the selected image
  bool isLoading = false; // Loading state

  String _validateEmail = "";
  String _validateName = "";

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProviders>(context, listen: false)
        .initConnectivity();
    _fetchUserProfile();
  }

  @override
  void dispose() {
    Provider.of<ConnectivityProviders>(context, listen: false).dispose();
    super.dispose();
  }

  void _validateFields() {
    setState(() {
      isLoading = true;
      _validateName =
          fullnameController.text.isEmpty ? "Please enter username" : "";
      _validateEmail =
          !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                  .hasMatch(emailController.text)
              ? "Please enter a valid email address (e.g. user@domain.com)"
              : "";

      if (_validateName.isEmpty && _validateEmail.isEmpty){
        _updateProfile();
      } else {
        isLoading = false;
      }
    });
  }

  String profile_image = "";
  String UserID="";

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

  Future<void> _fetchUserProfile() async {
    try {
      final profile_provider =
          Provider.of<UserDetailsProvider>(context, listen: false);
      var res = await profile_provider.userDetails;
      setState(() {
        if (res != null) {
          fullnameController.text = res.username ?? "";
          emailController.text = res.email ?? '';
          profile_image = res.photo ?? "";
          UserID = res.id.toString() ?? "";
        }
      });
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  Future<int?> _updateProfile() async {
    String fullname = fullnameController.text;
    String email = emailController.text;
    // String pwd = pwdController.text;
    final profile_provider =
        Provider.of<UserDetailsProvider>(context, listen: false);
    var response =
        await profile_provider.updateUserDetails(UserID,fullname, email, _image,context);
    setState(() {
      if (response != null) {
        isLoading = false;
        Navigator.pop(context);
        CustomSnackBar.show(context, "${response}");
      } else {
        isLoading = false;
        CustomSnackBar.show(context, "${response}");
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    var connectiVityStatus = Provider.of<ConnectivityProviders>(context);
    return (connectiVityStatus.isDeviceConnected == "ConnectivityResult.wifi" ||
            connectiVityStatus.isDeviceConnected == "ConnectivityResult.mobile")
        ? Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(
              fontSize: 22,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context,true);
          },
        ),
      ),
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey,
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : (profile_image != null && profile_image.isNotEmpty)
                                ? CachedNetworkImageProvider(profile_image)
                                : const AssetImage('assets/person.png') as ImageProvider<Object>,
                            child: (profile_image != null && profile_image.isNotEmpty)
                                ? null
                                : Icon(Icons.person, size: 50, color: Colors.white),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: _pickImage,
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: color28,
                                  size: 20, // Size of the camera icon
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Label(text: 'Full Name'),
                    SizedBox(height: 4),
                    _buildTextField(
                      controller: fullnameController,
                      hint: "Enter Name",
                      focusNode: _focusNodeFullName,
                    ),
                    if (_validateName.isNotEmpty)
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                        width: w * w,
                        child: ShakeWidget(
                          key: Key("value"),
                          duration: Duration(milliseconds: 700),
                          child: Text(
                            _validateName,
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12,
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: 16),
                    Label(text: 'Email'),
                    SizedBox(height: 4),
                    _buildTextField(
                      readonly: true,
                      controller: emailController,
                      hint: "Enter Email Address",
                      focusNode: _focusNodeEmail,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r"[a-zA-Z0-9@._-]")),
                      ],
                    ),
                    // if (_validateEmail.isNotEmpty)
                    //   Container(
                    //     alignment: Alignment.topLeft,
                    //     margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                    //     width: w * w,
                    //     child: ShakeWidget(
                    //       key: Key("value"),
                    //       duration: Duration(milliseconds: 700),
                    //       child: Text(
                    //         _validateEmail,
                    //         style: TextStyle(
                    //           fontFamily: "Poppins",
                    //           fontSize: 12,
                    //           color: Colors.red,
                    //           fontWeight: FontWeight.w500,
                    //
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // SizedBox(height: 16),
                    // Label(text: 'PassWord'),
                    SizedBox(height: 100),
                    InkResponse(
                      onTap: () {
                        if (isLoading) {
                        } else {
                          _validateFields();
                        }
                      },
                      child: Container(
                        width: w,
                        height: MediaQuery.of(context).size.height * 0.060,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Center(
                          child:
                          isLoading
                       ? CircularProgressIndicator(color: Colors.white,):
                          Text(
                            "SAVE",
                            style: TextStyle(
                              color: color4,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              height: 21 / 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : NoInternetWidget();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required FocusNode focusNode,
    bool readonly= false,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.05,
      child: TextFormField(
        readOnly: readonly,
        controller: controller,
        focusNode: focusNode,
        inputFormatters: inputFormatters,
        cursorColor: color28,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 14,
            letterSpacing: 0,
            height: 25.73 / 14,
            color: color29,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: const Color(0xffFCFAFF),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(width: 1, color: color28),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(width: 1, color: color28),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(width: 1, color: color28),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(width: 1, color: color28),
          ),
        ),
        style: TextStyle(
          fontSize: 14,
          fontFamily: 'RozhaOne',
          overflow: TextOverflow.ellipsis,
        ),
        textAlignVertical: TextAlignVertical.center,
      ),
    );
  }

  Widget Label({required String text, TextAlign? textalign}) {
    return Text(
      text,
      textAlign: textalign,
      style: TextStyle(
        color: Color(0xff110B0F),
        fontFamily: 'RozhaOne',
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
