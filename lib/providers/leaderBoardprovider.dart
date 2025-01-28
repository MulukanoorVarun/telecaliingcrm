import 'package:flutter/cupertino.dart';
import 'package:telecaliingcrm/model/LeadeBoardModel.dart';
import 'package:telecaliingcrm/services/UserApi.dart';

class LeaderBoardProvider extends ChangeNotifier {
  List<LeaderBoard> leaderboardData = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  int _currentPage = 1;
  LeaderBoard?  photo;

  int get currentPage => _currentPage;
  bool _hasNext = false;

  bool get hasNext => _hasNext;
  bool _pageLoading = false;

  bool get pageLoading => _pageLoading;
  // String _profile_image = "";
  // String get profile_image=>_profile_image;

  Future<void> fetchLeaderboardData() async {
    _isLoading = true;
    _currentPage = 1;
    notifyListeners();
    try {
      var res = await Userapi.getLeaderboard(_currentPage);
      if (res != null) {
        leaderboardData = res.leaderboardData ?? [];
        // Update `_hasNext` based on the API response
        _hasNext = res.nextPageUrl != null;
      } else {
        print("No leaderboard data found.");
      }
    } catch (e) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMoreLeaderboardData() async {
    // Prevent redundant calls if no more pages or a fetch is already in progress
    if (!_hasNext || _pageLoading) {
      debugPrint("No more pages to fetch or another fetch is in progress.");
      return;
    }

    _pageLoading = true; // Mark as loading
    notifyListeners();

    try {
      debugPrint("Fetching leaderboard data for page $_currentPage...");

      var res = await Userapi.getLeaderboard(_currentPage + 1); // Increment the page for the API call

      if (res != null) {
        _currentPage++; // Increment the page count on success

        leaderboardData.addAll(res.leaderboardData ?? []); // Append new leaderboard data

        // Update `_hasNext` based on the API response
        _hasNext = res.nextPageUrl != null;

        debugPrint(_hasNext
            ? "More leaderboard data available, preparing for next page."
            : "No more leaderboard data to fetch.");
      } else {
        debugPrint("No leaderboard data found.");
      }
    } catch (e) {
      // Log errors for debugging
      debugPrint("Error while fetching leaderboard data: $e");
    } finally {
      _pageLoading = false; // Reset loading state
      notifyListeners();    // Notify listeners of state change
    }
  }

}
