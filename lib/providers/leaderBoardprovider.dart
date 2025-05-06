import 'package:flutter/cupertino.dart';
import 'package:telecaliingcrm/model/LeadeBoardModel.dart';
import 'package:telecaliingcrm/services/UserApi.dart';

import '../model/GetIndustriesModel.dart';
import '../model/GetServicesModel.dart';
import '../model/GetStagesModel.dart';
import '../model/ViewInfoModel.dart';

class LeaderBoardProvider extends ChangeNotifier {
  List<LeaderBoard> leaderboardData = [];
  List<Services> _services = [];
  List<Stages> _stages = [];
  List<Industires> _industires = [];
  List<ViewInfo> _leadinfo = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<Services> get services => _services;
  List<Stages> get stages => _stages;
  List<Industires> get industires => _industires;
  List<ViewInfo> get leadinfo => _leadinfo;

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

  Future<void> getData(id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await Future.wait([
        fetchServices(),
        fetchIndustires(),
        fetchStages(),
      ]);
    } catch (e) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getLeadsInformationApi(String id) async {
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
