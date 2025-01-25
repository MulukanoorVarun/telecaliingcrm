import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';  // For ChangeNotifier
import '../Services/UserApi.dart';
import '../model/DashBoardModel.dart';

class DashboardProvider with ChangeNotifier {
  List<PhoneNumbers>? phone_numbers=[];
  String? todayCalls;
  String? pendingCalls;
  String? leadCount;
  String? followup_count;
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
        // If expecting Strings, convert integer values to Strings
        todayCalls = response?.todayCalls?.toString(); // Convert to String
        pendingCalls = response?.pendingCalls?.toString(); // Convert to String
        leadCount = response?.leadCount?.toString(); // Convert to String
        followup_count = response?.followupCount?.toString(); // Convert to String
        phone_numbers = response?.phoneNumbers??[];
        notifyListeners();
        _isLoading=false;
        return response?.status;
      } else {
        phone_numbers = null;
        _isLoading=false;
        notifyListeners();
        return response?.status;
      }
      // Notify listeners that the data has been updated
    } catch (e) {
      // If an error occurs, log or rethrow an exception
      print('Error fetching dashboard details: $e');
      throw Exception('Failed to dashboard details: $e');
    }
  }


}

