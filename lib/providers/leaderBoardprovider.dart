import 'package:flutter/cupertino.dart';
import 'package:telecaliingcrm/model/LeadeBoardModel.dart';
import 'package:telecaliingcrm/services/UserApi.dart';

import '../model/GetIndustriesModel.dart';
import '../model/GetServicesModel.dart';
import '../model/GetStagesModel.dart';
import '../model/ViewInfoModel.dart';

class LeaderBoardProvider extends ChangeNotifier {
  List<LeaderBoard> leaderboardData = [];


  bool _isLoading = false;
  bool get isLoading => _isLoading;


  int _currentPage = 1;
  LeaderBoard? photo;

  int get currentPage => _currentPage;
  bool _hasNext = false;

  bool get hasNext => _hasNext;
  bool _pageLoading = false;

  bool get pageLoading => _pageLoading;
  // String _profile_image = "";
  // String get profile_image=>_profile_image;

  Future<bool?> fetchLeaderboardData(String filter) async {
    _isLoading = true;
    _currentPage = 1;
    notifyListeners();
    try {
      var res = await Userapi.getLeaderboard(_currentPage, filter);
      if (res != null) {
        leaderboardData = res.leaderboardData ?? [];
        _hasNext = res.nextPageUrl != null;
        return true;
      } else {
        debugPrint("No leaderboard bloc found.");
        return false;
      }
    } catch (e) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<void> fetchMoreLeaderboardData(filter) async {
    // Prevent redundant calls if no more pages or a fetch is already in progress
    if (!_hasNext || _pageLoading) {
      debugPrint("No more pages to fetch or another fetch is in progress.");
      return;
    }
    _pageLoading = true; // Mark as loading
    notifyListeners();

    try {
      debugPrint("Fetching leaderboard bloc for page $_currentPage...");
      var res = await Userapi.getLeaderboard(
          _currentPage + 1, filter); // Increment the page for the API call
      if (res != null) {
        _currentPage++; // Increment the page count on success

        leaderboardData
            .addAll(res.leaderboardData ?? []); // Append new leaderboard bloc

        // Update `_hasNext` based on the API response
        _hasNext = res.nextPageUrl != null;

        debugPrint(_hasNext
            ? "More leaderboard bloc available, preparing for next page."
            : "No more leaderboard bloc to fetch.");
      } else {
        debugPrint("No leaderboard bloc found.");
      }
    } catch (e) {
      // Log errors for debugging
      debugPrint("Error while fetching leaderboard bloc: $e");
    } finally {
      _pageLoading = false; // Reset loading state
      notifyListeners(); // Notify listeners of state change
    }
  }

}
