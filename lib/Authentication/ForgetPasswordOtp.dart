import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:telecaliingcrm/Authentication/PasswordReset.dart';
import 'package:telecaliingcrm/Authentication/SetNewPassword.dart';
import 'package:telecaliingcrm/Services/otherservices.dart';
import 'package:telecaliingcrm/providers/ConnectivityProviders.dart';
import 'package:telecaliingcrm/utils/ShakeWidget.dart';

import '../Services/UserApi.dart';
import '../utils/ColorConstants.dart';
import '../utils/constants.dart';

class ForgotOTPscreen extends StatefulWidget {
  final String email;
  const ForgotOTPscreen({super.key, required this.email});

  @override
  State<ForgotOTPscreen> createState() => _ForgotOTPscreenState();
}

class _ForgotOTPscreenState extends State<ForgotOTPscreen> {
  final TextEditingController otpController = TextEditingController();
  final FocusNode focusNodeOTP = FocusNode();
  bool _loading = false;
  String validateOTP = "";

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
      validateOTP =
          otpController.text.length < 6 ? "Please enter a valid OTP" : "";
      if (validateOTP.isEmpty) {
        ForgotpasswordOtpVerifyApi();
      } else {
        _loading = false;
      }
    });
  }

  Future<void> ForgotpasswordApi() async {
    var res= await Userapi.forgetPassword(widget.email,context);
    if(res!=null){
      setState(() {
        _loading = false;
        if(res==true){
        }else{
        }
      });
    }
  }
  Future<void> ForgotpasswordOtpVerifyApi() async {
    var res =
        await Userapi.forgetPasswordOtpVerify(widget.email, otpController.text,context);
    if (res != null) {
      setState(() {
         _loading = false;
        if (res == true) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SetnewpasswordScreen(
                  email: widget.email,
                ),
              ));
        } else {}
      });
    }
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
          'CHECK YOUR EMAIL',
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
              RichText(
                text: TextSpan(
                  style: TextStyle(
                      fontSize: 13,
                      color: color2,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w400), // Default text style
                  children: <TextSpan>[
                    TextSpan(
                      text: 'We sent a reset link to ',
                    ),
                    TextSpan(
                      text: '${widget.email}',
                      style: TextStyle(
                        color: color11,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('Email clicked');
                        },
                    ),
                    TextSpan(
                      text:
                          '\nEnter 5 digit code that mentioned in the email',
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              PinCodeTextField(
                autoUnfocus: true,
                appContext: context,
                pastedTextStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                length: 6,
                blinkWhenObscuring: true,
                autoFocus: true,
                autoDismissKeyboard: false,
                showCursor: true,
                animationType: AnimationType.fade,
                focusNode: focusNodeOTP,
                hapticFeedbackTypes: HapticFeedbackTypes.heavy,
                controller: otpController,
                onTap: () {
                  setState(() {
                    validateOTP = "";
                  });
                },
                onChanged: (v) {
                  setState(() {
                    validateOTP = "";
                  });
                },
                pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: h * 0.06,
                    fieldWidth: w * 0.11,
                    fieldOuterPadding: EdgeInsets.only(left: 0, right: 3),
                    activeFillColor: Color(0xFFF4F4F4),
                    activeColor: Color(0xff110B0F),
                    selectedColor: Color(0xff110B0F),
                    selectedFillColor: Color(0xFFF4F4F4),
                    inactiveFillColor: Color(0xFFF4F4F4),
                    inactiveColor: Color(0xFFD2D2D2),
                    inactiveBorderWidth: 1.5,
                    selectedBorderWidth: 2,
                    activeBorderWidth: 1),
                textStyle: TextStyle(
                    fontFamily: "RozhaOne",
                    fontSize: 17,
                    fontWeight: FontWeight.w400),
                cursorColor: Colors.black,
                enableActiveFill: true,
                keyboardType: TextInputType.numberWithOptions(),
                textInputAction: (Platform.isAndroid)
                    ? TextInputAction.none
                    : TextInputAction.done,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                boxShadows: const [
                  BoxShadow(
                    offset: Offset(0, 1),
                    color: Colors.black12,
                    blurRadius: 10,
                  )
                ],
                enablePinAutofill: true,
                useExternalAutoFillGroup: true,
                beforeTextPaste: (text) {
                  return true;
                },
              ),
              if (validateOTP.isNotEmpty) ...[
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(bottom: 5),
                  child: ShakeWidget(
                    key: Key("value"),
                    duration: Duration(milliseconds: 700),
                    child: Text(
                      validateOTP,
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
                height: w * 0.25,
              ),
              Center(
                child: Image.asset(
                  "assets/forgototp.png",
                  width: 215,
                  height: 150,
                ),
              ),
              SizedBox(
                height: w * 0.42,
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
                    height: 55,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                          :  text(context, 'RESET PASSWORD', 16,
                          color: color4,
                          fontfamily: "Inter",
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: h * 0.02,
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black, // Default text color
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Haven’t got the email yet? ",
                      style: TextStyle(
                        color: Color(0xff989898),
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: "Resend email",
                      style: TextStyle(
                        color: Color(0xff648DDB),
                        fontWeight: FontWeight.w600,
                        fontFamily: "Inter",
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        ForgotpasswordApi();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ): NoInternetWidget();
  }
}
