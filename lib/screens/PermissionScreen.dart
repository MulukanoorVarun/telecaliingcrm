
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telecaliingcrm/screens/dashboard.dart';
import 'package:telecaliingcrm/utils/ColorConstants.dart';
import '../Authentication/SignInScreen.dart';
import '../utils/PermissionManager.dart';
import '../utils/preferences.dart';

class PermissionScreen extends StatefulWidget {
  @override
  _PermissionScreenState createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  bool allPermissionsGranted = false;
  String token = "";

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    Fetchdetails();
  }

  // Fetch user token or details
  Fetchdetails() async {
    var Token = (await PreferenceService().getString('token')) ?? "";
    setState(() {
      token = Token;
    });
  }

  Future<void> _checkPermissions() async {
    final granted = await PermissionManager.checkPermissions(
      context,
      onPermissionStatusChanged: (granted) {
        setState(() {
          allPermissionsGranted = granted;
        });
      },
    );
    setState(() {
      allPermissionsGranted = granted;
    });
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 20, left: 16, right: 16),
        child: ElevatedButton(
          onPressed: allPermissionsGranted
              ? () {
            if(token!=""){
              context.pushReplacement("/dashboard");
            }else{
              context.pushReplacement("/signin");
            }
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
