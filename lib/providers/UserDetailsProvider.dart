// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';  // For ChangeNotifier
// import '../Model/UserDetailsModel.dart';
// import '../Services/UserApi.dart';
//
// class UserDetailsProvider with ChangeNotifier {
//   UserDetail? _userdetails;
//
//   // Getter for userDetails that ensures null safety
//   UserDetail? get userDetails => _userdetails;
//
//   // Method to fetch user details asynchronously
//   Future<int?> fetchUserDetails() async {
//     try {
//       // Fetching user details from the API
//       var response = await Userapi.getUserdetsils();
//       if (response?.settings?.success==1) {
//         _userdetails = response?.data;
//         notifyListeners();
//         return response?.settings?.success??0;
//       } else {
//         _userdetails = null;
//         notifyListeners();
//         return response?.settings?.success??0;
//       }
//
//       // Notify listeners that the data has been updated
//     } catch (e) {
//       // If an error occurs, log or rethrow an exception
//       print('Error fetching user details: $e');
//       throw Exception('Failed to fetch user details: $e');
//     }
//   }
//
//   // Method to fetch user details asynchronously
//   Future<int?> updateUserDetails(name,mobile,email,File? image) async {
//     try {
//       // Fetching user details from the API
//       var response = await Userapi.updateProfile(name,mobile,email,image);
//       if (response?.data != null) {
//         fetchUserDetails();
//         return response?.settings?.success??0;
//       } else {
//         return response?.settings?.success??0;
//       }
//     } catch (e) {
//       // If an error occurs, log or rethrow an exception
//       print('Error updating user details: $e');
//       throw Exception('Failed to updating user details: $e');
//     }
//   }
//
//
//
// }
//
