
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SubscriptionExpiredScreen extends StatelessWidget {
  const SubscriptionExpiredScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop(); // Close the app
        return false; // Prevent default back action
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 100,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 20),
              const Text(
                'Your Subscription Has Expired',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'To continue enjoying the services, please renew your subscription.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
