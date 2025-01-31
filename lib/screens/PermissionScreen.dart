import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telecaliingcrm/utils/ColorConstants.dart';

import '../Authentication/SignInScreen.dart';

class PermissionScreen extends StatefulWidget {
  @override
  _PermissionScreenState createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  bool allPermissionsGranted = false;

  @override
  void initState() {
    super.initState();
    checkPermissions(); // Check permissions when screen loads
  }

  Future<void> checkPermissions() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo android = await plugin.androidInfo;
    List<Permission> requiredPermissions = [
      Permission.phone,
      Permission.contacts,
      Permission.camera,
    ];

    if (android.version.sdkInt < 33) {
      requiredPermissions.add(Permission.storage);  // Deprecated in Android 13+
    }else{
      print("isAndroid11orAbove");
      requiredPermissions.add(Permission.photos);
    }

    // Request permissions
    Map<Permission, PermissionStatus> statuses = {};
    for (var permission in requiredPermissions) {
      statuses[permission] = await permission.request();
    }

    // Check if all required permissions are granted
    setState(() {
      allPermissionsGranted = statuses.values.every((status) => status.isGranted);
    });

    // Handle denied or permanently denied permissions
    if (!allPermissionsGranted) {
      _handleDeniedPermissions(statuses);
    }
  }

  void _handleDeniedPermissions(Map<Permission, PermissionStatus> statuses) {
    List<Permission> deniedPermissions = statuses.entries
        .where((entry) => entry.value.isDenied)
        .map((entry) => entry.key)
        .toList();

    List<Permission> permanentlyDeniedPermissions = statuses.entries
        .where((entry) => entry.value.isPermanentlyDenied)
        .map((entry) => entry.key)
        .toList();

    if (permanentlyDeniedPermissions.isNotEmpty) {
      _showPermanentlyDeniedDialog();
    } else if (deniedPermissions.isNotEmpty) {
      _showPermissionDeniedDialog(deniedPermissions);
    }
  }

  void _showPermissionDeniedDialog(List<Permission> deniedPermissions) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Permissions Required"),
        content: Text(
            "The app needs the following permissions: ${deniedPermissions.join(", ")}. Please grant them to continue.",style: TextStyle(  fontFamily: 'Poppins',)),
        actions: [
          TextButton(
            child: Text("Retry",style: TextStyle(  fontFamily: 'Poppins',)),
            onPressed: () {
              Navigator.of(context).pop();
              checkPermissions(); // Retry permission request
            },
          ),
        ],
      ),
    );
  }

  void _showPermanentlyDeniedDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Permissions Denied"),
        content: Text(
            "Some permissions have been permanently denied. Please enable them in Settings.",style: TextStyle(  fontFamily: 'Poppins',)),
        actions: [
          TextButton(
            child: Text("Go to Settings",style: TextStyle(  fontFamily: 'Poppins',),),
            onPressed: () {
              Navigator.of(context).pop();
              SystemNavigator.pop();
              openAppSettings(); // Open app settings
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Permissions',
          style: TextStyle(
              fontSize: 22,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            SystemNavigator.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPermissionItem(
                icon: Icons.phone,
                title: "Phone",
                description: "Required to make and manage calls within the app.",
              ),
              _buildPermissionItem(
                icon: Icons.contacts,
                title: "Contacts",
                description: "Needed to access your contacts for seamless communication.",
              ),
              _buildPermissionItem(
                icon: Icons.camera_alt,
                title: "Camera",
                description: "Allow access to your camera for capturing photos and videos.",
              ),
              _buildPermissionItem(
                icon: Icons.folder,
                title: "Storage",
                description: "Grant access to store and retrieve media, documents, and files.",
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 20, left: 16, right: 16),
        child: ElevatedButton(
          onPressed: allPermissionsGranted
              ? () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => SignInScreen()));
          }
              : null, // Disable button if permissions are not granted
          style: ElevatedButton.styleFrom(
            backgroundColor: allPermissionsGranted ? primaryColor : Colors.grey.withOpacity(0.5),
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            'GET STARTED',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey.withOpacity(0.3),
            ),
            child: Center(
              child: Icon(
                icon,
                color:primaryColor,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w300,
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
