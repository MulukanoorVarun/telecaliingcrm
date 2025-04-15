import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For ChangeNotifier
import '../Services/UserApi.dart';
import '../model/LeadsModel.dart';
import '../screens/SubscriptionExpiredScreen.dart';
import '../utils/constants.dart';

class LeadsProvider with ChangeNotifier {
  List<Leads> leadslist=[];
  bool _isLoading = true;
  bool _hasNextPage = true;
  List<Leads>? get leadsList => leadslist;
  bool get isLoading => _isLoading;
  bool get hasNextPage => _hasNextPage;
  int _currentPage = 1; // Track the current page number
  int get currentPage => _currentPage;
  bool _pageLoading = false;  // Loading state
  bool get pageLoading => _pageLoading;


  Future<void> fetchLeadsList(type) async {
    _isLoading = true;
    _currentPage = 1;
    leadslist =[];
    notifyListeners();
    try {
      var result = await Userapi.getLeads(type, _currentPage);
      if (result?.status == true) {
        leadslist = result?.data?.leadslist ?? [];
        if(result?.data?.nextPageUrl!=null){
          _hasNextPage = true;
          notifyListeners();
          print("fetchLeadsList Called  _hasNextPage = true;");
        }else{
          _hasNextPage = false;
          notifyListeners();
          print("fetchLeadsList Called  _hasNextPage = false");
        }
        notifyListeners();
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
  Future<void> fetchMoreLeadsList(String type) async {
    if (!_hasNextPage || _pageLoading) {
      return;
    }
    _pageLoading = true;
    notifyListeners();

    try {
      var result = await Userapi.getLeads(type, _currentPage + 1);

      if (result?.status == true) {
        _currentPage++; // Increment the current page after a successful fetch.
        leadslist.addAll(result?.data?.leadslist ?? []);

        _hasNextPage = result?.data?.nextPageUrl != null; // Check for more pages.
      } else {
        _hasNextPage = false; // No more pages.

      }
    } catch (e) {
      print('Error fetching more leads: $e');
    } finally {
      _pageLoading = false; // Reset loading state.
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
          fetchLeadsList('');
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

  Future<bool?> UpdateleadsApi(name, leadID, remarks, leadStatusID, leadStageID) async {
    try {
      var response = await Userapi.postUpdateLeads(
        name,
        leadID,
        remarks,
        leadStatusID,
        leadStageID
      );
      if (response != null) {
        if (response["status"] == true) {
          fetchLeadsList('');
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
