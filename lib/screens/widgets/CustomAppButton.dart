import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/ColorConstants.dart';


class CustomAppButton extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final Color? color;
  final double? width;
  final double? height;
  final VoidCallback? onPlusTap;
  CustomAppButton({
    Key? key,
    required this.text,
    required this.onPlusTap,
    this.color,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width ?? w,
      height: height ?? 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          backgroundColor: color ?? primaryColor,
          foregroundColor: color ?? primaryColor,
          disabledBackgroundColor:color ?? primaryColor,
          disabledForegroundColor:color ?? primaryColor,
          shadowColor: Colors.transparent,
          overlayColor: Colors.transparent,
        ),
        onPressed: onPlusTap,
        child: Text(
          text,
          style: TextStyle(
            color: Color(0xffFFFFFF),
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontFamily: 'lexend',
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => throw UnimplementedError();
}


class CustomAppButton1 extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final Color? color;
  final double? width;
  final double? height;
  final VoidCallback? onPlusTap;
  final bool isLoading;
  CustomAppButton1({
    Key? key,
    required this.text,
    required this.onPlusTap,
    this.color,
    this.height,
    this.width,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width ?? w,
      height: height ?? 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          backgroundColor: color ?? primaryColor.withOpacity(0.5),
          foregroundColor: color ?? primaryColor.withOpacity(0.5),
          disabledBackgroundColor:color ?? primaryColor.withOpacity(0.5),
          disabledForegroundColor:color ?? primaryColor.withOpacity(0.5),
          shadowColor: Colors.transparent,
          overlayColor: Colors.transparent,
        ),
        onPressed: isLoading ? null : onPlusTap,
        child: isLoading
            ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 2,
          ),
        )
            : Text(
          text,
          style: TextStyle(
            color: Color(0xffFFFFFF),
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontFamily: 'lexend',
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => throw UnimplementedError();
}