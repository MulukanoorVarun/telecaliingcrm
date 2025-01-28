import 'package:flutter/material.dart';
import 'package:telecaliingcrm/Authentication/SignInScreen.dart';
import 'package:telecaliingcrm/utils/ShakeWidget.dart';

import '../Services/UserApi.dart';
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

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool _loading = false;
  String validatePassword = "";
  String validateConfirmPassword = "";

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
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
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  text(context, 'SET NEW PASSWORD', 18,
                      color: color11,
                      fontfamily: "Inter",
                      fontWeight: FontWeight.w700),
                ],
              ),
              SizedBox(
                height: 35,
              ),
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
    );
  }
}
