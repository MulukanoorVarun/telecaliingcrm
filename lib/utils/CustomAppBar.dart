import 'package:flutter/material.dart';
import 'package:telecaliingcrm/utils/constants.dart';


class CustomAppBar2 extends StatelessWidget implements PreferredSizeWidget {
  final double w;
  final String title;

  CustomAppBar2({required this.title, required this.w});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: Icon(
        Icons.arrow_back_sharp,
        color: color4,
      ),
      actions: <Widget>[Container()],
      toolbarHeight: 50,
      backgroundColor: color28,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          title,
          style: TextStyle(
            color: Color(0xffffffff),
            fontFamily: 'Poppins',
            fontSize: 24,
            height: 32 / 24,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}
