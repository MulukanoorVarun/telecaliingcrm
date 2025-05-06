import 'package:flutter/material.dart';

import '../Services/UserApi.dart';
import '../model/FollowUpTypesModel.dart';
import '../model/GetFollowUpModel.dart';
import '../model/GetFollowupByIDModel.dart';
import '../screens/SubscriptionExpiredScreen.dart';

class FollowupProvider extends ChangeNotifier {
  bool _isLoading = true;
  List<FollowUp> _followuplist = [];
  List<FollowUpTypes> _followuptypes = [];
  GetFollowupByIDModel? _selectedFollowUp; // Store the fetched follow-up

  bool _pageLoading = false;
  bool get pageLoading => _pageLoading;

  bool _nextPage = true;
  bool get nextPage => _nextPage;

  int _currentPage = 1;
  int get currentpage => _currentPage;

  bool get isLoading => _isLoading;
  List<FollowUp> get followupList => _followuplist;
  List<FollowUpTypes> get followupTypes => _followuptypes;
  GetFollowupByIDModel? get selectedFollowUp => _selectedFollowUp; // Getter

  Future<bool> getFollowUpApi(String filter) async {
    _isLoading = true;
    _currentPage = 1;
    notifyListeners();
    try {
      var result = await Userapi.getFollowup(_currentPage, filter);
      if (result?.status == true) {
        _followuplist = result?.data?.followUps ?? [];
        if (result?.data?.nextPageUrl != null) {
          _nextPage = true;
        } else {
          _nextPage = false;
        }
        return true;
      } else {
        _followuplist = [];
        debugPrint("Failed to update the call status.");
        return false;
      }
    } catch (error) {
      debugPrint("Error fetching follow-up bloc: $error");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMoreFollowUpList(String filter) async {
    // Prevent redundant calls if no next page or a call is already in progress
    if (!_nextPage || _pageLoading) {
      debugPrint("No more pages to fetch or another fetch is in progress.");
      return;
    }

    _pageLoading = true; // Mark as loading
    notifyListeners();

    try {
      debugPrint("Fetching page $_currentPage...");
      var result = await Userapi.getFollowup(
          _currentPage + 1, filter); // Increment the page for API call

      if (result?.status == true) {
        _currentPage++; // Increment the current page only after a successful fetch

        _followuplist.addAll(result?.data?.followUps ?? []);

        // Update nextPage flag based on the API response
        _nextPage = result?.data?.nextPageUrl != null;

        debugPrint(_nextPage
            ? "Next page available, fetching more."
            : "No more pages to fetch.");
      } else {
        // Handle API failure, e.g., show a subscription expired page
        debugPrint(
            "API returned failure status, redirecting to subscription screen...");
        _followuplist = []; // Clear the list on failure
        _nextPage = false; // Stop fetching more
      }
    } catch (error) {
      // Catch and log the error
      debugPrint("Error fetching follow-up bloc: $error");
    } finally {
      _pageLoading = false; // Reset the loading state
      notifyListeners(); // Notify listeners of the state change
    }
  }

  Future<bool?> AddFollowUp(Map<String,dynamic> data) async {
    try {
      final res = await Userapi.postAddFollowUp(data);
      if (res != null) {
        if (res["status"] == true) {
          getFollowUpApi("Open");
          return true;
        } else {
          return false;
        }
      } else {
        debugPrint("Failed to add Follow-up: Response is null.");
      }
    } catch (e) {
      // Handle any errors
      debugPrint("Error occurred while adding Follow-up: $e");
    }
    return false;
  }

  Future<bool?> updateFollowUp(Map<String,dynamic> data,id) async {
    try {
      final res = await Userapi.updateFollowUp(data,id);
      if (res != null) {
        if (res["status"] == true) {
          getFollowUpApi("Open");
          return true;
        } else {
          return false;
        }
      } else {
        debugPrint("Failed to updateFollowUp : Response is null.");
      }
    } catch (e) {
      // Handle any errors
      debugPrint("Error occurred while updateFollowUp: $e");
    }
    return false;
  }

  Future<bool?> deleteFollowUp(id) async {
    try {
      final res = await Userapi.deleteFollowUp(id);
      if (res != null) {
        if (res["status"] == true) {
          getFollowUpApi("Open");
          return true;
        } else {
          return false;
        }
      } else {
        debugPrint("Failed to add Follow-up: Response is null.");
      }
    } catch (e) {
      // Handle any errors
      debugPrint("Error occurred while adding Follow-up: $e");
      return false;
    }
    return false;
  }

  Future<bool> getFollowUpTypes() async {
    try {
      var result = await Userapi.getFollowupTypes();
      if (result?.status == true) {
        _followuptypes = result?.followuptypes ?? [];
        return true;
      } else {
        _followuptypes = [];
        debugPrint("Failed to update the call status.");
        return false;
      }
    } catch (error) {
      debugPrint("Error fetching getFollowUpTypes: $error");
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> getFollowUpByID(String id) async {
    try {
      var result = await Userapi.getFollowupByID(id);
      if (result != null) {
        _selectedFollowUp = result; // Store the GetFollowupByIDModel
        notifyListeners();
        return true;
      } else {
        _selectedFollowUp = null;
        debugPrint("Failed to fetch follow-up by ID: Response is null");
        return false;
      }
    } catch (error) {
      _selectedFollowUp = null;
      debugPrint("Error fetching getFollowUpByID: $error");
      return false;
    } finally {
      notifyListeners();
    }
  }


}
