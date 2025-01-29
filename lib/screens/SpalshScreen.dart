import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';
import 'package:telecaliingcrm/Authentication/SignInScreen.dart';
import 'package:telecaliingcrm/screens/OnBoardingScreen.dart';
import '../Services/otherservices.dart';
import '../providers/ConnectivityProviders.dart';
import '../utils/ColorConstants.dart';
import '../utils/preferences.dart';
import 'dashboard.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late ConnectivityProviders _connectivityProvider;

  String token = "";
  String onboard_status = "";
  @override
  void initState() {
    super.initState();
    // Save the provider reference during initState
    _connectivityProvider =
        Provider.of<ConnectivityProviders>(context, listen: false);
    _connectivityProvider.initConnectivity();
    // Initialize animation controller
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (await isNetworkAvailable()) {
        await checkForUpdates();
        await handleNavigation();
      } else {}
    });


    Fetchdetails();
  }

  Future<bool> isNetworkAvailable() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Fetch user token or details
  Fetchdetails() async {
    var Token = (await PreferenceService().getString('token')) ?? "";
    var status = (await PreferenceService().getString('onboard_status')) ?? "";
    setState(() {
      onboard_status = status;
      token = Token;
    });
  }

  // Method to check for mandatory updates
  Future<void> checkForUpdates() async {
    try {
      final info = await InAppUpdate.checkForUpdate();

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        if (info.immediateUpdateAllowed) {
          // Force the immediate update before proceeding
          await InAppUpdate.performImmediateUpdate().then((result) {
            if (result == AppUpdateResult.success) {
              print("Update completed successfully!");
            } else {
              print("Update not completed. App cannot proceed.");
              _showUpdateRequiredDialog();
            }
          });
        } else {
          print("Immediate update not allowed. Exiting.");
        }
      } else {
        print("No update available. Proceeding.");
      }
    } catch (e) {
      print("Update check failed: $e");
    }
  }

  // Show dialog when an update is mandatory
  void _showUpdateRequiredDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Update Required"),
        content: Text(
            "A new version of the app is available. You must update to continue."),
        actions: [
          TextButton(
            onPressed: () async {
              await checkForUpdates();
            },
            child: Text("Retry"),
          ),
        ],
      ),
    );
  }


  Future<void> handleNavigation() async {
    // Navigate after update and animation complete
    await Future.delayed(Duration(seconds: 3));
    if (onboard_status == '') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => OnBoardindScreen()));
    } else if (token.isNotEmpty) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignInScreen()));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var connectiVityStatus = Provider.of<ConnectivityProviders>(context);
    return (connectiVityStatus.isDeviceConnected == "ConnectivityResult.wifi" ||
            connectiVityStatus.isDeviceConnected == "ConnectivityResult.mobile")
        ? Scaffold(
            backgroundColor: primaryColor,
            body: Container(
              child: Center(
                child: FadeTransition(
                  opacity: _animation,
                  child: Image.asset(
                    "assets/telecalling_splash.png",
                    width: 240,
                    height: 200,
                  ),
                ),
              ),
            ),
          )
        : NoInternetWidget();
  }
}
