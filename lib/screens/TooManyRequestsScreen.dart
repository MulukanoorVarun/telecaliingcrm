import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TooManyRequestsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(  onWillPop: () async {
      SystemNavigator.pop(); // Close the app
      return false; // Prevent default back action
    },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 80,
                ),
                SizedBox(height: 20),
                Text(
                  "Too Many Requests!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "You've made too many requests in a short period.\nPlease wait a moment before trying again.",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
