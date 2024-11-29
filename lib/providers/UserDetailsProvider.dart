import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';  // For ChangeNotifier
import '../Services/UserApi.dart';
import '../model/UserDetailsModel.dart';

class UserDetailsProvider with ChangeNotifier {
  UserDetailsModel? _userDetails;

  UserDetailsModel? get userDetails => _userDetails;

  Future<int?> fetchUserDetails() async {
    try {
      // Fetch the user details from the API
      var response = await Userapi.getUserDetails();
      if (response != null) {
        _userDetails = response;
        notifyListeners();
      }
    } catch (e) {
      // Log error and notify listeners
      print('Error fetching user details: $e');
      _userDetails = null;
      notifyListeners();
      return null; // Optionally return a specific code for errors
    }
  }
}


