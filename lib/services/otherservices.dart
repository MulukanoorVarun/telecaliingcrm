import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:telecaliingcrm/utils/preferences.dart';

import '../utils/constants.dart';


Future<Map<String, String>> getheader() async {
  final sessionid = await PreferenceService().getString("token");
  print(sessionid);
  String Token = "Bearer ${sessionid}";
  Map<String, String> headers = {
    'Authorization': Token,
    'Content-Type': 'multipart/form-data'
  };
  return headers;
}

// Future<Map<String, String>> getheader1() async {
//   final sessionid = await PreferenceService().getString("token");
//   print(sessionid);
//   String Token = "Bearer ${sessionid}";
//   Map<String, String> headers = {
//     'Authorization': Token,
//   };
//   return headers;
// }

Future<Map<String, String>> getheader1() async {
  final sessionid = await PreferenceService().getString("token");
  print(sessionid);
  String Token = "Bearer $sessionid";
  Map<String, String> headers = {
    'Authorization': Token,
  };
  return headers;
}

Future<Map<String, String>> getheader2() async {
  final sessionid = await PreferenceService().getString("token");
  print(sessionid);
  String Token = "Bearer ${sessionid}";
  Map<String, String> headers = {
    'Authorization': Token,
    'Content-Type': 'application/x-www-form-urlencoded',
  };
  return headers;
}

// CheckHeaderValidity() async {
//   String timestamp =
//   DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10);
//   final token = await PreferenceService().getString("refresh_token");
//   final validityTimestamp =
//   await PreferenceService().getString("access_expiry_timestamp");
//   var status = true;
//   if (int.parse(validityTimestamp!) <= int.parse(timestamp)) {
//     await UserApi.UpdateRefreshToken(token).then((data) => {
//       if (data != null)
//         {
//           var response = data,
//           PreferenceService()
//               .saveString("access_token", response.accessToken!),
//           PreferenceService().saveString(
//               "access_expiry_timestamp", response.accessExpiryTimestamp!),
//           status = true,
//           // if(response!.error=="1"){
//           //         return true,
//           //       }else{
//           //     return false,
//           //   }
//         }
//       else
//         {status = false}
//     });
//   } else {
//     status = true;
//   }
//   return status;
// }

class NoInternetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/no_internet.png",
              width: 200,
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 48),
              child: Text(
                "Connect to the Internet",
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 20,
                  fontFamily: 'RozhaOne',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 13),
              child: Text(
                "You are Offline. Please Check Your Connection",
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 16,
                  fontFamily: 'RozhaOne',
                  fontWeight: FontWeight.w400,

                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                final connectivityResult = await Connectivity().checkConnectivity();
                String message;

                if (connectivityResult == ConnectivityResult.mobile) {
                  message = "Connected to Mobile Network";
                } else if (connectivityResult == ConnectivityResult.wifi) {
                  message = "Connected to WiFi";
                } else {
                  message = "No Internet Connection";
                }
                CustomSnackBar.show(context, message);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 38),
                child: Container(
                  width: 240,
                  height: 46,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: const Color(0xff000000),
                  ),
                  child: const Center(
                    child: Text(
                      "Retry",
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 20,
                        fontFamily: 'RozhaOne',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





