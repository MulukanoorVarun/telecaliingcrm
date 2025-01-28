import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionDeniedScreen extends StatelessWidget {
  const PermissionDeniedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permission Required'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 100,
              color: Colors.orangeAccent,
            ),
            const SizedBox(height: 20),
            const Text(
              'Permission Denied',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'To access your call logs and phone, please grant the necessary permissions. '
                  'You can enable the permissions in your app settings.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await Permission.phone.request();
                await Permission.contacts.request();

                var phoneStatus = await Permission.phone.status;
                var callLogStatus = await Permission.contacts.status;

                if (phoneStatus.isGranted && callLogStatus.isGranted) {
                  // Handle granted state (redirect or perform actions)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Permissions granted successfully!")),
                  );
                } else {
                  // Show message if still denied
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Permissions are still denied.")),
                  );
                }
              },
              child: const Text('Request Permissions'),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () {
                openAppSettings();
              },
              child: const Text(
                'Open App Settings',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
