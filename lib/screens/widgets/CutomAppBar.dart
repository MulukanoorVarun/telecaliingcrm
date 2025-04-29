import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/ColorConstants.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final VoidCallback? voidCallbackAction;

  CustomAppBar({Key? key, required this.title, required this.actions, this.voidCallbackAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        style: ButtonStyle(
          visualDensity: VisualDensity.comfortable,
          side: MaterialStateProperty.all(BorderSide(color: Colors.grey)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        onPressed: voidCallbackAction ?? () {
          // Default action if voidCallbackAction is null
          context.pop(true);
        },
        icon: Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'lexend',
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}



class CustomAppBar1 extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;

  const CustomAppBar1({Key? key, required this.title, required this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: primaryColor,
      leading: IconButton.outlined(
        style: ButtonStyle(
          side: MaterialStateProperty.all(BorderSide(color: Colors.black)),
          shape: MaterialStateProperty.all(
            CircleBorder()
          ),
        ),
        visualDensity: VisualDensity.compact,
        onPressed: () {
          context.pop(true);
        },
        icon: Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'lexend',
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
