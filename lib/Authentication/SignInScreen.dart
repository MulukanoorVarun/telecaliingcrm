import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:telecaliingcrm/screens/HomeScreen.dart';

import '../utils/ShakeWidget.dart';
import '../utils/constants.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final FocusNode _focusNodePhone = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  String _validatePhone = "";
  String _validatePwd = "";
  bool _loading = false;
  bool _obscureText = true;

  void _validateFields() {
    setState(() {
      _loading = true;

      _validatePhone =
          _phoneController.text.isEmpty || _phoneController.text.length < 10
              ? "Please enter a valid phonenumber"
              : "";
      _validatePwd =
          _pwdController.text.isEmpty ? "Please enter a password" : "";

      if (_validatePhone.isEmpty && _validatePwd.isEmpty) {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Homescreen()));
      } else {
        _loading = false;
      }
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
                controller: _phoneController,
                focusNode: _focusNodePhone,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Only allow digits
                  LengthLimitingTextInputFormatter(10),
                ],
                cursorColor: color28,
                onTap: () {
                  setState(() {
                    _validatePhone = "";
                  });
                },
                onChanged: (v) {
                  setState(() {
                    _validatePhone = "";
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
            if (_validatePhone.isNotEmpty) ...[
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                width: MediaQuery.of(context).size.width * 0.6,
                child: ShakeWidget(
                  key: Key("value"),
                  duration: Duration(milliseconds: 700),
                  child: Text(
                    _validatePhone,
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
