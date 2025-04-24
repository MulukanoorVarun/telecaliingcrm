import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:telecaliingcrm/Services/UserApi.dart';
import 'package:telecaliingcrm/utils/preferences.dart';

import '../utils/constants.dart';


Future<Map<String, String>> getheader() async {
  final sessionid = await PreferenceService().getString("token");
  String Token = "Bearer ${sessionid}";
  Map<String, String> headers = {
    'Authorization': Token,
    'Content-Type': 'multipart/form-bloc'
  };
  return headers;
}

Future<Map<String, String>> getheader1() async {
  final sessionid = await PreferenceService().getString("token");
  String Token = "Bearer $sessionid";
  Map<String, String> headers = {
    'Authorization': Token,
  };
  return headers;
}

Future<Map<String, String>> getheader2() async {
  final sessionid = await PreferenceService().getString("token");
  String Token = "Bearer ${sessionid}";
  Map<String, String> headers = {
    'Authorization': Token,
    'Content-Type': 'application/x-www-form-urlencoded',
  };
  return headers;
}

Future<bool> checkHeaderValidity() async {
  // Get the current timestamp in milliseconds
  int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
  final int? validityTimestampInSeconds = await PreferenceService().getInt("access_expiry_timestamp");

  // Convert validityTimestamp to milliseconds
  int? validityTimestampInMilliseconds = validityTimestampInSeconds != null
      ? validityTimestampInSeconds * 1000
      : null;

  debugPrint("validityTimestampInMilliseconds: $validityTimestampInMilliseconds");
  debugPrint("currentTimestamp: $currentTimestamp");

  if (validityTimestampInMilliseconds == null || validityTimestampInMilliseconds <= currentTimestamp) {
    // Token has expired or no valid timestamp
    final data = await Userapi.updateRefreshToken();
    if (data != null) {
      // Check if the API response indicates success
      if (data["success"] == true) {
        debugPrint("Successfully got the token");
        PreferenceService().saveString('token', data['access_token']);
        // Assuming `expires_in` is in seconds, save the expiry time in milliseconds
        PreferenceService().saveInt('access_expiry_timestamp', ((currentTimestamp ~/ 1000) + data['expires_in']).toInt());
        return true;
      } else {
        // If the success key is not true, return false
        return false;
      }
    } else {
      // No bloc returned, returning false
      return false;
    }
  }
  return true;
}






