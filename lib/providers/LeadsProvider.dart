import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For ChangeNotifier
import '../Services/UserApi.dart';
import '../model/GetFollowupByIDModel.dart';
import '../model/GetFollowupByLeadIDModel.dart';
import '../model/GetIndustriesModel.dart';
import '../model/GetServicesModel.dart';
import '../model/GetStagesModel.dart';
import '../model/LeadsModel.dart';
import '../model/ViewInfoModel.dart';
import '../screens/SubscriptionExpiredScreen.dart';
import '../utils/constants.dart';

class LeadsProvider with ChangeNotifier {
  List<Lead> leadslist = [];
  bool _isLoading = true;
  bool _hasNextPage = true;
  List<Lead>? get leadsList => leadslist;
  List<Data> _selectedFollowUpByLead = [];
  List<ViewInfo> _leadinfo = [];
  bool get isLoading => _isLoading;
  bool get hasNextPage => _hasNextPage;
  List<ViewInfo> get leadinfo => _leadinfo;
  int _currentPage = 1;
  int get currentPage => _currentPage;
  bool _pageLoading = false;
  bool get pageLoading => _pageLoading;
  List<Data> get selectedFollowUpByLead => _selectedFollowUpByLead;

  List<Services> _services = [];
  List<Stages> _stages = [];
  List<Industires> _industires = [];


  List<Services> get services => _services;
  List<Stages> get stages => _stages;
  List<Industires> get industires => _industires;

  Future<void> fetchLeadsList(type) async {
    _isLoading = true;
    _currentPage = 1;
    leadslist.clear();
    notifyListeners();
    try {
      var result = await Userapi.getLeads(type, _currentPage);
      debugPrint('fetchLeadsList API Response: $result');
      debugPrint(
          'Status: ${result?.status}, LeadsList: ${result?.data.data}, NextPageUrl: ${result?.data.nextPageUrl}');

      if (result?.status == true) {
        leadslist = result?.data.data ?? [];
        _hasNextPage = result?.data.nextPageUrl != null;
        debugPrint(
            'fetchLeadsList Success - LeadsList Length: ${leadslist.length}, hasNextPage: $_hasNextPage');
      } else {
        leadslist = result?.data.data ?? [];
        _hasNextPage = false;
        debugPrint(
            'fetchLeadsList Failed - LeadsList Length: ${leadslist.length}, hasNextPage: $_hasNextPage');
      }
    } catch (e) {
      debugPrint('Error fetching Leads list: $e');
      throw Exception('Failed to fetch Leads list: $e');
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
        _currentPage++;
        leadslist.addAll(result?.data.data ?? []);

        _hasNextPage =
            result?.data.nextPageUrl != null; // Check for more pages.
      } else {
        _hasNextPage = false; // No more pages.
      }
    } catch (e) {
      debugPrint('Error fetching more leads: $e');
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
      debugPrint('Error adding lead: $e');
      throw Exception('Failed to add lead: $e');
    }
    return null;
  }

  Future<bool?> UpdateleadsApi(Map<String, dynamic> data) async {
    try {
      var response = await Userapi.postUpdateLeads(data);
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
      debugPrint('Error updating user details: $e');
      throw Exception('Failed to updating user details: $e');
    }
    return null;
  }

  Future<void> getLeadsInformationApi(id) async {
    _isLoading = true;
    notifyListeners();
    try {
      var result = await Userapi.getViewInfo(id);
      if (result?.status == true) {
        _leadinfo = result?.data ?? [];
        debugPrint("Response: $result");
      } else {
        debugPrint("Failed to fetch leads information");
      }
    } catch (e) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> getFollowUpByLeadID(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      var result = await Userapi.getFollowupByLeadID(id);
      if (result != null) {
        _selectedFollowUpByLead = result.data ?? [];
        notifyListeners();
        return true;
      } else {
        _selectedFollowUpByLead = [];
        debugPrint("Failed to fetch follow-up by ID: Response is null");
        return false;
      }
    } catch (error) {
      _selectedFollowUpByLead = [];
      debugPrint("Error fetching getFollowUpByID: $error");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getData(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await Future.wait([
        fetchServices(),
        fetchIndustires(),
        fetchStages(),
        getLeadsInformationApi(id), // Fetch lead-specific information
      ]);
      debugPrint('Fetched Data: Services: ${_services.length}, Industries: ${_industires.length}, Stages: ${_stages.length}, LeadInfo: ${_leadinfo.length}');
    } catch (e) {
      debugPrint('Error in getData: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> fetchServices() async {
    _isLoading = true;
    notifyListeners();
    try {
      var res = await Userapi.getServices();
      if (res != null) {
        _services = res.services ?? [];
      } else {
        debugPrint("No leaderboard bloc found.");
      }
    } catch (e) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchIndustires() async {
    _isLoading = true;
    notifyListeners();
    try {
      var res = await Userapi.getIndustires();
      if (res != null) {
        _industires = res.industires ?? [];
      } else {
        debugPrint("No leaderboard bloc found.");
      }
    } catch (e) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchStages() async {
    _isLoading = true;
    notifyListeners();
    try {
      var res = await Userapi.getStages();
      if (res != null) {
        _stages = res.stages ?? [];
      } else {
        debugPrint("No leaderboard bloc found.");
      }
    } catch (e) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
