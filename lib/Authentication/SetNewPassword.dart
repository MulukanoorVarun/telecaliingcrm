import 'package:flutter/material.dart';
import 'package:telecaliingcrm/Authentication/SignInScreen.dart';

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
      validateConfirmPassword =
          password.text.isEmpty ? "Please enter a valid confirm password" : "";
      if (validatePassword.isEmpty && validateConfirmPassword.isEmpty) {
        SetnewPasswordApi();
      } else {
        _loading = false;
      }
    });
  }

  Future<void> SetnewPasswordApi() async {
    // await Userapi.ResetPassword(
    //         widget.email, password.text, confirmpassword.text)
    //     .then((data) => {
    //           setState(() {
    //             if (data != null) {
    //               if (data.settings?.success == 1) {
    //                 _loading = false;
    //                 Navigator.pushReplacement(
    //                     context,
    //                     MaterialPageRoute(
    //                         builder: (context) => SignInScreen()));
    //               } else {
    //                 _loading = false;
    //                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //                   content: Text(
    //                     data.settings?.message ?? "",
    //                     style: TextStyle(color: Color(0xff000000)),
    //                   ),
    //                   duration: Duration(seconds: 1),
    //                   // backgroundColor: color1,
    //                 ));
    //               }
    //             }
    //           })
    //         });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: w,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/Drug Clam Background.png',
                  ),
                  fit: BoxFit.cover)),
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
                    Icon(Icons.arrow_back),
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
                SizedBox(
                  height: w * 1,
                ),
                InkWell(
                  onTap: () {
                    if (_loading) {
                    } else {
                      _validateFields();
                    }
                  },
                  child: Center(
                    child: Container(
                      width: w,
                      height: 60,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          // color: color1
                      ),
                      child: Center(
                        child: text(context, 'UPDATE PASSWORD', 16,
                                color: color4,
                                fontfamily: "Inter",
                                fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
