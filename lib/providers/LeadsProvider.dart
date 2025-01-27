import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For ChangeNotifier
import '../Services/UserApi.dart';
import '../model/DashBoardModel.dart';
import '../model/LeadsModel.dart';

class LeadsProvider with ChangeNotifier {
  List<Leads>? leadslist;
  bool _isLoading = false;
  bool _hasNextPage = true;
  List<Leads>? get leadsList => leadslist;
  bool get isLoading => _isLoading;
  bool get hasNextPage => _hasNextPage;
  int _currentPage = 1; // Track the current page number
  int get currentPage => _currentPage;
  bool _pageLoading = false;  // Loading state
  bool get pageLoading => _pageLoading;


  Future<bool?> fetchLeadsList(type) async {
    _isLoading = true;
    _currentPage = 1;
    notifyListeners();
    try {
      var result = await Userapi.getLeads(type, _currentPage);
      if (result?.status == true) {
        leadslist = result?.data?.leadslist ?? [];
        if(result?.data?.nextPageUrl!= null){
          _hasNextPage = true;
        }else{
          _hasNextPage = false;
        }
      } else {
        leadslist = result?.data?.leadslist ?? [];
        _hasNextPage = false;
      }
    } catch (e) {
      // If an error occurs, log or rethrow an exception
      print('Error fetching Leads list: $e');
      throw Exception('Failed to Leads list: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool?> fetchMoreLeadsList(type) async {
    _currentPage ++;
    _pageLoading=true;
    notifyListeners();
    try {
      var result = await Userapi.getLeads(type,_currentPage);
      if (result?.status == true) {
        leadslist?.addAll(result?.data?.leadslist ?? []);
        if(result?.data?.nextPageUrl!=null){
          _hasNextPage = true;
        }else{
          _hasNextPage = false;
        }
      } else {
        leadslist?.addAll(result?.data?.leadslist ?? []);
        _hasNextPage = false;
      }
    } catch (e) {
      // If an error occurs, log or rethrow an exception
      print('Error fetching Leads list: $e');
      throw Exception('Failed to Leads list: $e');
    } finally {
      _pageLoading = false;
      notifyListeners();
    }
  }

  Future<bool?> AddleadsApi(name, mobile, date, remarks, leadStatus) async {
    try {
      // Fetching user details from the API
      var response =
          await Userapi.postAddLeads(name, mobile, date, remarks, leadStatus);
      if (response != null) {
        if (response["status"] == true) {
          fetchLeadsList('all');
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
          fetchLeadsList('all');
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
