import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:telecaliingcrm/screens/HomeScreen.dart';

import '../services/UserApi.dart';
import '../utils/ShakeWidget.dart';
import '../utils/constants.dart';
import '../utils/preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  String _validateEmail = "";
  String _validatePwd = "";
  bool _loading = false;
  bool _obscureText = true;

  void _validateFields() {
    setState(() {
      _loading = true;

          _validateEmail = !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(_emailController.text)
          ? "Please enter a valid email address (e.g. user@domain.com)"
          : "";
      _validatePwd =
          _pwdController.text.isEmpty ? "Please enter a password" : "";

      if (_validateEmail.isEmpty && _validatePwd.isEmpty) {
        SignIn();
      } else {
        _loading = false;
      }
    });
  }


  Future<void> SignIn() async {
    setState(() {
      _loading = true;
    });

    await Userapi.PostSignIn(_emailController.text, _pwdController.text).then((data) {
      setState(() {
        _loading = false;
      });

      if (data != null) {
        if (data['access_token'] != null) {
          // Successful login
          PreferenceService().saveString('token', data['access_token']);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Homescreen()),
          );
        } else if (data['error'] != null) {
          // Authentication error
          CustomSnackBar.show(context, data['error']);
        } else if (data['email'] != null || data['password'] != null) {
          // Validation error
          String emailError = (data['email'] != null) ? data['email'].join(", ") : "";
          String passwordError = (data['password'] != null) ? data['password'].join(", ") : "";
          CustomSnackBar.show(context, "$emailError $passwordError".trim());
        } else {
          // Unexpected response
          CustomSnackBar.show(context, "An unexpected error occurred.");
        }
      } else {
        // Null response
        CustomSnackBar.show(context, "Failed to sign in. Please try again.");
      }
    }).catchError((error) {
      setState(() {
        _loading = false;
      });
      // Handle exceptions
      CustomSnackBar.show(context, "Error: $error");
    });
  }



  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: color28,
      body: Padding(
        padding: EdgeInsets.only(top: h * 0.16, left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/telecalling_splash.png',
              fit: BoxFit.contain,
              height: h * 0.12,
              width: w,
            ),
            SizedBox(
              height: h * 0.1,
            ),
            Label(text: 'Mobile Number'),
            SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height * 0.06,
              child: TextFormField(
                controller: _emailController,
                focusNode: _focusNodeEmail,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9@._-]")),
                ],
                cursorColor: color28,
                onTap: () {
                  setState(() {
                    _validateEmail = "";
                  });
                },
                onChanged: (v) {
                  setState(() {
                    _validateEmail = "";
                  });
                },
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  hintText: "Enter Mobile Number",
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
                  fontSize: 14, // Ensure font size fits within height
                  overflow: TextOverflow.ellipsis,
                  fontFamily: 'Inter',
                ),
                textAlignVertical: TextAlignVertical.center,
              ),
            ),
            if (_validateEmail.isNotEmpty) ...[
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                width: MediaQuery.of(context).size.width * 0.6,
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
              SizedBox(height: 8),
            ],
            Label(text: 'Password'),
            SizedBox(height: 4),
            Container(
              height: MediaQuery.of(context).size.height * 0.060,
              child: TextFormField(
                obscureText: _obscureText,
                controller: _pwdController,
                focusNode: _focusNodePassword,
                keyboardType: TextInputType.text,
                cursorColor: color28,
                onTap: () {
                  setState(() {
                    _validatePwd = "";
                  });
                },
                onChanged: (v) {
                  setState(() {
                    _validatePwd = "";
                  });
                },
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  hintText: "Enter Password",
                  hintStyle: TextStyle(
                    fontSize: 15,
                    letterSpacing: 0,
                    height: 25.73 / 15,
                    color: color29,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      size: 20,
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: color28,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: const Color(0xffFCFAFF),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: BorderSide(width: 1, color: color28),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide:
                        const BorderSide(width: 1, color: Color(0xffd0cbdb)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide:
                        const BorderSide(width: 1, color: Color(0xffd0cbdb)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide:
                        const BorderSide(width: 1, color: Color(0xffd0cbdb)),
                  ),
                ),
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Inter',
                  overflow: TextOverflow.ellipsis, // Add ellipsis for long text
                ),
                textAlignVertical: TextAlignVertical.center,
              ),
            ),
            if (_validatePwd.isNotEmpty) ...[
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                width: MediaQuery.of(context).size.width * 0.6,
                child: ShakeWidget(
                  key: Key("value"),
                  duration: Duration(milliseconds: 700),
                  child: Text(
                    _validatePwd,
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
              SizedBox(height: 8),
            ],
            SizedBox(height: h*0.06,),
            containertext(context, 'LOGIN',color: color11,onTap: (){
              if (_loading) {
              } else {
                _validateFields();
              }

            })
          ],
        ),
      ),
    );
  }
}
