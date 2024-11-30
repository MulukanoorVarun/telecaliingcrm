import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';  // For ChangeNotifier
import '../Services/UserApi.dart';
import '../model/DashBoardModel.dart';

class DashboardProvider with ChangeNotifier {
  List<PhoneNumbers>? phone_numbers;
  int? todayCalls;
  int? pendingCalls;
  int? leadCount;
  int? followup_count;
  bool _isLoading = true;

  // Getter for userDetails that ensures null safety
  List<PhoneNumbers>? get phoneNumbers => phone_numbers;
  bool get isLoading => _isLoading;

  // Method to fetch user details asynchronously
  Future<bool?> fetchDashBoardDetails() async {
    try {
      // Fetching user details from the API
      var response = await Userapi.DahsBoardApi();
      if (response?.status==true) {
        todayCalls=response?.todayCalls;
        pendingCalls=response?.pendingCalls;
        leadCount=response?.leadCount;
        followup_count = response?.followupCount;
        phone_numbers =response?.phoneNumbers;
        notifyListeners();
        _isLoading=false;
        return response?.status;
      } else {
        phone_numbers = null;
        notifyListeners();
        _isLoading=false;
        return response?.status;
      }
      // Notify listeners that the data has been updated
    } catch (e) {
      // If an error occurs, log or rethrow an exception
      print('Error fetching dashboard details: $e');
      throw Exception('Failed to dashboard details: $e');
    }
  }

  // // Method to fetch user details asynchronously
  // Future<int?> updateUserDetails(name,mobile,email,File? image) async {
  //   try {
  //     // Fetching user details from the API
  //     var response = await Userapi.updateProfile(name,mobile,email,image);
  //     if (response?.data != null) {
  //       fetchUserDetails();
  //       return response?.settings?.success??0;
  //     } else {
  //       return response?.settings?.success??0;
  //     }
  //   } catch (e) {
  //     // If an error occurs, log or rethrow an exception
  //     print('Error updating user details: $e');
  //     throw Exception('Failed to updating user details: $e');
  //   }
  // }



}

