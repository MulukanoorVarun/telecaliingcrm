import 'package:flutter/material.dart';

import '../Services/UserApi.dart';
import '../model/GetFollowUpModel.dart';
import '../screens/SubscriptionExpiredScreen.dart';

class FollowupProvider extends ChangeNotifier {
  bool _isLoading = true;
  List<FollowUpModel> _followuplist = [];

  bool _pageLoading = false;
  bool get pageLoading => _pageLoading;

  bool _nextPage = true;
  bool get nextPage => _nextPage;

  int _currentPage = 1;
  int get currentpage => _currentPage;

  bool get isLoading => _isLoading;
  List<FollowUpModel> get followupList => _followuplist;

  Future<void> getFollowUpApi(BuildContext context) async {
    _isLoading = true;
    _currentPage = 1;
    notifyListeners();
    try {
      var result = await Userapi.getFollowup(_currentPage,context);
      if (result?.status == true) {
        _followuplist = result?.data?.followup_list ?? [];
        if(result?.data?.nextPageUrl!=null){
          _nextPage = true;
        }else{
          _nextPage = false;
        }
      } else {
        _followuplist = [];
        debugPrint("Failed to update the call status.");
      }
    } catch (error) {
      debugPrint("Error fetching follow-up data: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMoreFollowUpList(BuildContext context) async {
    // Prevent redundant calls if no next page or a call is already in progress
    if (!_nextPage || _pageLoading) {
      debugPrint("No more pages to fetch or another fetch is in progress.");
      return;
    }

    _pageLoading = true; // Mark as loading
    notifyListeners();

    try {
      debugPrint("Fetching page $_currentPage...");
      var result = await Userapi.getFollowup(_currentPage + 1,context); // Increment the page for API call

      if (result?.status == true) {
        _currentPage++; // Increment the current page only after a successful fetch

        _followuplist.addAll(result?.data?.followup_list ?? []);

        // Update nextPage flag based on the API response
        _nextPage = result?.data?.nextPageUrl != null;

        debugPrint(_nextPage
            ? "Next page available, fetching more."
            : "No more pages to fetch.");
      } else {
        // Handle API failure, e.g., show a subscription expired page
        debugPrint("API returned failure status, redirecting to subscription screen...");
        _followuplist = []; // Clear the list on failure
        _nextPage = false;  // Stop fetching more
      }
    } catch (error) {
      // Catch and log the error
      debugPrint("Error fetching follow-up data: $error");
    } finally {
      _pageLoading = false; // Reset the loading state
      notifyListeners();    // Notify listeners of the state change
    }
  }


  Future<bool?> AddFollowUp(BuildContext context,id,name,date,remaks ) async {
    try {
      final res = await Userapi.postAddFollowUp(id,name,date,remaks,context);
      if (res!= null) {
        if(res["status"]==true){
          getFollowUpApi(context);
          return true;
        }else{
          return false;
        }
      } else {
        print("Failed to add Follow-up: Response is null.");
      }
    } catch (e) {
      // Handle any errors
      print("Error occurred while adding Follow-up: $e");
    }
  }



}
