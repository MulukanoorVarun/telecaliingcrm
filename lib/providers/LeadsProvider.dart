import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For ChangeNotifier
import '../Services/UserApi.dart';
import '../model/DashBoardModel.dart';
import '../model/LeadsModel.dart';

class LeadsProvider with ChangeNotifier {
  List<Leads>? leadslist;
  bool _isLoading = true;

  // Getter for userDetails that ensures null safety
  List<Leads>? get leadsList => leadslist;
  bool get isLoading => _isLoading;

  // Method to fetch user details asynchronously
  Future<bool?> fetchLeadsList() async {
    try {
      var result = await Userapi.getLeads();
      if (result?.status == true) {
        leadslist = result?.data ?? [];
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      // If an error occurs, log or rethrow an exception
      print('Error fetching Leads list: $e');
      throw Exception('Failed to Leads list: $e');
    }
  }

  Future<bool?> AddleadsApi(name, mobile, date, remarks, leadStatus) async {
    try {
      // Fetching user details from the API
      var response =
          await Userapi.postAddLeads(name, mobile, date, remarks, leadStatus);
      if (response != null) {
        if (response["status"] == true) {
          fetchLeadsList();
          return response["status"];
        } else {
          return response["status"];
        }
      }
    } catch (e) {
      // If an error occurs, log or rethrow an exception
      print('Error adding lead: $e');
      throw Exception('Failed to add lead: $e');
    }
    return null;
  }

  Future<bool?> UpdateleadsApi(
      name, leadID, remarks, leadStatusID, leadStageID) async {
    try {
      // Fetching user details from the API
      var response = await Userapi.postUpdateLeads(
        name,
        leadID,
        remarks,
        leadStatusID,
        leadStageID,
      );
      ;
      if (response != null) {
        if (response["status"] == true) {
          fetchLeadsList();
          return response["status"];
        } else {
          return response["status"];
        }
      }
    } catch (e) {
      // If an error occurs, log or rethrow an exception
      print('Error updating user details: $e');
      throw Exception('Failed to updating user details: $e');
    }
    return null;
  }
}
