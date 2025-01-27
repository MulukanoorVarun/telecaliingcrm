
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:telecaliingcrm/utils/ShakeWidget.dart';
import 'package:telecaliingcrm/utils/constants.dart';

class Forgotpasswordscreen extends StatefulWidget {
  const Forgotpasswordscreen({super.key});

  @override
  State<Forgotpasswordscreen> createState() => _ForgotpasswordscreenState();
}

class _ForgotpasswordscreenState extends State<Forgotpasswordscreen> {

  final TextEditingController email = TextEditingController();

  @override
  void initState() {
    super.initState();

  }

  bool _loading = false;
  String _validateEmail = ""; // Corrected the typo here

  void _validateFields() {
    setState(() {
      _loading = true;
      _validateEmail =
      !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
          .hasMatch(email.text)
          ? "Please enter a valid email"
          : "";
      if (_validateEmail.isEmpty) {
        ForgotpasswordApi();
      } else {
        _loading = false;
      }
    });
  }

  Future<void> ForgotpasswordApi() async {
    // await Userapi.ForgetPasswordOTP(email.text).then((data) {
    //   setState(() {
    //     if (data != null) {
    //       if (data.settings?.success == 1) {
    //         _loading = false;
    //         Navigator.pushReplacement(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => ForgotOTPscreen(
    //               email: email.text,
    //             ),
    //           ),
    //         );
    //       } else {
    //         _loading = false;
    //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //           content: Text(
    //             data.settings?.message ?? "",
    //             style: TextStyle(color: Color(0xff000000)),
    //           ),
    //           duration: Duration(seconds: 1),
    //           backgroundColor: color1,
    //         ));
    //       }
    //     }
    //   });
    // });
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
              image: AssetImage('assets/Drug Clam Background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            margin: EdgeInsets.only(top: 30),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color4,
              borderRadius: BorderRadius.all(Radius.circular(8)),
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
                    text(
                      context,
                      'FORGOT PASSWORD',
                      18,
                      color: color11,
                      fontfamily: "Inter",
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                SizedBox(
                  height: 45,
                ),
                text(
                  context,
                  'Please enter your email to reset the password',
                  14,
                  color: color2,
                  textAlign: TextAlign.start,
                  fontfamily: "Inter",
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 54,
                  child: TextField(
                    controller: email,
                    decoration: InputDecoration(
                      hintText: "Email",
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
                if (_validateEmail.isNotEmpty) ...[
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(bottom: 5),
                    child: ShakeWidget(
                      key: Key("value"),
                      duration: Duration(milliseconds: 700),
                      child: Text(
                        _validateEmail,
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
                  height: w * 0.2,
                ),
                Center(
                  child: Image.asset(
                    "assets/forgotpassword.png",
                    width: 280,
                    height: 250,
                  ),
                ),
                SizedBox(
                  height: w * 0.3,
                ),
                InkWell(
                  onTap: () {
                    if (_loading) {

                      return;
                    } else {
                      _validateFields();
                    }
                  },
                  child: Center(
                    child: Container(
                      width: w,
                      height: 55,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),

                        ),
                        color: color28

                      ),
                      child: Center(
                        child: text(
                          context,
                          'RESET PASSWORD',
                          16,
                          color: color4,
                          fontfamily: "Inter",
                          fontWeight: FontWeight.w500,
                        ),
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
