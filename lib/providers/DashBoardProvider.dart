import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';  // For ChangeNotifier
import 'package:telecaliingcrm/screens/SubscriptionExpiredScreen.dart';
import '../Services/UserApi.dart';
import '../model/DashBoardModel.dart';

class DashboardProvider with ChangeNotifier {
  List<MobileNumbers>? phone_numbers;
  String? todayCalls;
  String? pendingCalls;
  String? leadCount;
  String? followup_count;
  bool _isLoading = true;

  // Getter for userDetails that ensures null safety
  List<MobileNumbers>? get phoneNumbers => phone_numbers;
  bool get isLoading => _isLoading;

  // Method to fetch user details asynchronously
  Future<bool?> fetchDashBoardDetails(BuildContext context) async {
    try {
      // Fetching user details from the API
      var response = await Userapi.DahsBoardApi(context);
      if (response?.status==true) {
        todayCalls = response?.todayCalls?.toString(); // Convert to String
        pendingCalls = response?.pendingCalls?.toString(); // Convert to String
        leadCount = response?.leadCount?.toString(); // Convert to String
        followup_count = response?.followupCount?.toString(); // Convert to String
        phone_numbers =response?.phoneNumbers?.data??[];
        _isLoading=false;
        notifyListeners();
        return true;
      } else {
        phone_numbers = [];
        _isLoading=false;
        notifyListeners();
        return false;
      }
      // Notify listeners that the data has been updated
    } catch (e) {
      // If an error occurs, log or rethrow an exception
      print('Error fetching dashboard details: $e');
      throw Exception('Failed to dashboard details: $e');
    }
  }


}

