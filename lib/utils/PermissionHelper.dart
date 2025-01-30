import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  /// Request all permissions and return `true` if granted, otherwise `false`
  static Future<bool> requestAllPermissions(BuildContext context) async {
    List<Permission> permissions = [
      Permission.phone,
      Permission.contacts,
      Permission.camera,
      Permission.storage,
    ];

      Map<Permission, PermissionStatus> statuses = await permissions.request();
      // Check if all permissions are granted
      bool allGranted = statuses.values.every((status) => status.isGranted);
      if (allGranted) {
        return true; // Return `true` when all permissions are granted
      }else{
        Map<Permission, PermissionStatus> statuses = await permissions.request();
        bool allGranted = statuses.values.every((status) => status.isGranted);
        if(allGranted){
          return true; // Return `true` when all permissions are granted
        }else{
          _showPermissionDialog(
            context,
            "Permissions Required",
            "Some permissions are permanently denied. Please enable them manually in settings.",
            forceSettings: true,
          );
        }
      }
    return false; // Ensure function always returns a value
  }

  /// Show a dialog if permissions are denied
  static void _showPermissionDialog(BuildContext context, String title, String content, {bool forceSettings = false}) {
    showDialog(
      barrierDismissible: !forceSettings, // Prevents dismissing if settings are required
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (forceSettings) {
                  openAppSettings(); // Open settings if forced
                }
              },
              child: Text(forceSettings ? "Open Settings" : "Try Again"),
            ),
          ],
        );
      },
    );
  }
}


