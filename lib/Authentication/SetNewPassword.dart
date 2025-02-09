import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telecaliingcrm/Authentication/SignInScreen.dart';
import 'package:telecaliingcrm/Services/otherservices.dart';
import 'package:telecaliingcrm/providers/ConnectivityProviders.dart';
import 'package:telecaliingcrm/utils/ShakeWidget.dart';

import '../Services/UserApi.dart';
import '../utils/ColorConstants.dart';
import '../utils/constants.dart';

class SetnewpasswordScreen extends StatefulWidget {
  final String email;
  const SetnewpasswordScreen({super.key, required this.email});

  @override
  State<SetnewpasswordScreen> createState() => _SetnewpasswordScreenState();
}

class _SetnewpasswordScreenState extends State<SetnewpasswordScreen> {
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmpassword = TextEditingController();

  bool _loading = false;
  String validatePassword = "";
  String validateConfirmPassword = "";

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


  void _validateFields() {
    setState(() {
      _loading = true;
      validatePassword =
          password.text.isEmpty ? "Please enter a valid password" : "";
      validateConfirmPassword = confirmpassword.text!=password.text?"Please entered password not match with above." : "";
      if (validatePassword.isEmpty &&
          validateConfirmPassword.isEmpty) {
        SetnewPasswordApi();
      } else {
        _loading = false;
      }
    });
  }

  Future<void> SetnewPasswordApi() async {
    var res = await Userapi.updatePassword(widget.email, password.text,context);
    if (res == true) {
      Navigator.pop(context);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    var connectiVityStatus = Provider.of<ConnectivityProviders>(context);
    return (connectiVityStatus.isDeviceConnected == "ConnectivityResult.wifi" ||
        connectiVityStatus.isDeviceConnected == "ConnectivityResult.mobile")
        ? Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor, // Set the background color of the AppBar
        leading: IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.only(left: 0),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white, // Change the color to match your theme
          ),
        ),
        title: text(
          context,
          'SET NEW PASSWORD',
          18,
          color: Colors.white,
          fontfamily: "Inter",
          fontWeight: FontWeight.w700,
        ),
        elevation: 0, // Removes the shadow
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 30),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: color4,
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text(
                  context,
                  'Create a new password. Ensure it differs from previous ones for security',
                  14,
                  color: color2,
                  textAlign: TextAlign.start,
                  fontfamily: "Inter",
                  fontWeight: FontWeight.w400),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 54,
                child: TextField(
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Enter Your New Password",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      letterSpacing: 0,
                      height: 1.2,
                      color: color,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    filled: true,
                    fillColor: Color(0xffFCFAFF),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(width: 1, color: color7),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(width: 1, color: color7),
                    ),
                  ),
                ),
              ),
              if (validatePassword.isNotEmpty) ...[
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(bottom: 5),
                  child: ShakeWidget(
                    key: Key("value"),
                    duration: Duration(milliseconds: 700),
                    child: Text(
                      validatePassword,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                const SizedBox(
                  height: 12,
                ),
              ],
              SizedBox(
                height: w * 0.07,
              ),
              Container(
                height: 54,
                child: TextField(
                  controller: confirmpassword,
                  decoration: InputDecoration(
                    hintText: "Re-Enter Your Password",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      letterSpacing: 0,
                      height: 1.2,
                      color: color,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    filled: true,
                    fillColor: Color(0xffFCFAFF),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(width: 1, color: color7),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(width: 1, color: color7),
                    ),
                  ),
                ),
              ),
              if (validateConfirmPassword.isNotEmpty) ...[
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(bottom: 5),
                  child: ShakeWidget(
                    key: Key("value"),
                    duration: Duration(milliseconds: 700),
                    child: Text(
                      validateConfirmPassword,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                const SizedBox(
                  height: 12,
                ),
              ],
              SizedBox(
                height: w * 0.8,
              ),
              InkWell(
                onTap: () {
                  if (_loading) {
                  } else {
                    _validateFields();
                  }
                },
                child: Container(
                  width: w,
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      color: color28),
                  child: Center(
                    child: _loading
                        ? CircularProgressIndicator(
                          color: color4,
                        )
                        :  text(context, 'UPDATE PASSWORD', 16,
                        color: color4,
                        fontfamily: "Inter",
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    ):NoInternetWidget();
  }
}
