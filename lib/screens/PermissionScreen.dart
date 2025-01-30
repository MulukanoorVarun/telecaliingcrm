import 'package:flutter/material.dart';
import 'package:telecaliingcrm/Authentication/SignInScreen.dart';
import '../utils/ColorConstants.dart';
import '../utils/PermissionHelper.dart';
import '../utils/constants.dart';
import '../utils/preferences.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});
  @override
  State<PermissionScreen> createState() => _PermissionState();
}

class _PermissionState extends State<PermissionScreen> {
  bool allPermissionsGranted = false;
  String token = "";

  @override
  void initState() {
    super.initState();
    Fetchdetails();
  }

  Fetchdetails() async {
    var Token = (await PreferenceService().getString('token')) ?? "";
    setState(() {
      token = Token;
    });
    print("Token: $token");
  }

  /// Function to check & request permissions
  Future<void> checkPermissions() async {
    bool granted = await PermissionHelper.requestAllPermissions(context);
    setState(() {
      allPermissionsGranted = granted;
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

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
            Navigator.pop(context);
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
        child: containertext(
          context,
          'GET STARTED',
          onTap: () {
            if(allPermissionsGranted){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
            }else{
              checkPermissions();
            }
          },
          color: allPermissionsGranted ? primaryColor : Colors.grey.withOpacity(0.5), // Disable button if permissions not granted
        ),
      ),
    );
  }

  Widget _buildPermissionItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return container(
      context,
      colors: color4,
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Color(0xFFCDE2FB),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: color11,
                    size: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Text(
              description,
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w300,
                  fontSize: 13,
                  color: color),
            ),
          ),
        ],
      ),
    );
  }

}
