import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:telecaliingcrm/Authentication/SignInScreen.dart';
import 'package:telecaliingcrm/screens/OnBoardingScreen.dart';
import '../Services/otherservices.dart';
import '../providers/ConnectivityProviders.dart';
import '../utils/ColorConstants.dart';
import '../utils/PermissionManager.dart';
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
    final statuses = await PermissionManager.checkPermissionStatuses();
    final allPermissionsGranted =
        statuses.values.every((status) => status.isGranted);

    setState(() {
      permissions_granted = allPermissionsGranted;
      debugPrint("permissions_granted: $permissions_granted");
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
              debugPrint("Update completed successfully!");
            } else {
              debugPrint("Update not completed. App cannot proceed.");
              _showUpdateRequiredDialog();
            }
          });
        } else {
          debugPrint("Immediate update not allowed. Exiting.");
        }
      } else {
        debugPrint("No update available. Proceeding.");
      }
    } catch (e) {
      debugPrint("Update check failed: $e");
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
      context.pushReplacement("/on_board");
    } else if (!permissions_granted) {
      context.pushReplacement("/permission");
    } else if (token.isNotEmpty) {
      context.pushReplacement("/dashboard");
    } else {
      context.pushReplacement("/signin");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
