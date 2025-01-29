import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';  // For ChangeNotifier
import '../Services/UserApi.dart';
import '../model/UserDetailsModel.dart';

class UserDetailsProvider with ChangeNotifier {
  UserDetailsModel? _userDetails;

  UserDetailsModel? get userDetails => _userDetails;

  Future<int?> fetchUserDetails(BuildContext context) async {
    try {
      // Fetch the user details from the API
      var response = await Userapi.getUserDetails(context);
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
    return null;
  }

  Future<String?> updateUserDetails(UserID,fullname, email, _image,BuildContext context) async{
    try{
      var response =await Userapi.updateProfile(UserID,fullname, email, _image,context);
      if (response!= null) {
        fetchUserDetails(context);
        return response;
      } else {
        return response;
      }
    } catch (e) {
      // If an error occurs, log or rethrow an exception
      print('Error updating user details: $e');
      throw Exception('Failed to updating user details: $e');
    }
  }
}

