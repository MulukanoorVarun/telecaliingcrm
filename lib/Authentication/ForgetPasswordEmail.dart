import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:telecaliingcrm/Authentication/ForgetPasswordOtp.dart';
import 'package:telecaliingcrm/services/UserApi.dart';
import 'package:telecaliingcrm/utils/ColorConstants.dart';
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
  String _validateEmail = "";

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
    var res = await Userapi.forgetPassword(email.text, context);
    try {
      if (res != null) {
        setState(() {
          _loading = false;
          if (res == true) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ForgotOTPscreen(
                  email: email.text,
                ),
              ),
            );
          } else {

          }
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
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
          'FORGOT PASSWORD',
          18,
          color: Colors.white,
          fontfamily: "Inter",
          fontWeight: FontWeight.w700,
        ),
        elevation: 0, // Removes the shadow
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 40),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color4,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text(
                context,
                'Email',
                14,
                color: color2,
                textAlign: TextAlign.start,
                fontfamily: "Inter",
                fontWeight: FontWeight.w400,
              ),
              SizedBox(
                height: 5,
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
                        color: color28),
                    child: Center(
                      child: _loading
                          ? CircularProgressIndicator(
                              color: color4,
                            )
                          : text(
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
    );
  }
}
