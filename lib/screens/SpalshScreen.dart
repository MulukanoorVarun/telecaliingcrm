import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:telecaliingcrm/Authentication/SignInScreen.dart';
import 'package:telecaliingcrm/screens/OnBoardingScreen.dart';
import '../Services/otherservices.dart';
import '../providers/ConnectivityProviders.dart';
import '../utils/ColorConstants.dart';
import '../utils/preferences.dart';
import 'PermissionScreen.dart';
import 'dashboard.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool permissions_granted = false;

  String token = "";
  String onboard_status = "";


  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProviders>(context, listen: false)
        .initConnectivity();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (await isNetworkAvailable()) {
        await checkForUpdates();
        await handleNavigation();
      } else {}
    });

    _checkPermissions();
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


  Future<void> _checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = {
     Permission.phone: await Permission.phone.status,
      Permission.camera: await Permission.camera.status,
      Permission.contacts: await Permission.contacts.status,
      Permission.storage: await Permission.storage.status,
    };

    bool allPermissionsGranted =
    statuses.values.every((status) => status.isGranted);

    setState(() {
      permissions_granted = allPermissionsGranted;
      print("permissions_granted:${permissions_granted}");
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
    } else if(!permissions_granted){
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => PermissionScreen()));
    }
    else if (token.isNotEmpty) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignInScreen()));
    }
  }

  @override
  void dispose() {
    Provider.of<ConnectivityProviders>(context, listen: false).dispose();
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
                child: Image.asset(
                  "assets/telecalling_splash.png",
                  width: 240,
                  height: 200,
                ),
              ),
            ),
          )
        : NoInternetWidget();
  }
}
