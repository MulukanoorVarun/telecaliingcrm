import 'package:flutter/cupertino.dart';
import 'package:telecaliingcrm/model/LeadeBoardModel.dart';
import 'package:telecaliingcrm/services/UserApi.dart';

class LeaderBoardProvider extends ChangeNotifier {
  List<LeaderBoard> leaderboardData = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  int _currentPage = 1;

  int get currentPage => _currentPage;
  bool _hasNext = false;

  bool get hasNext => _hasNext;
  bool _pageLoading = false;

  bool get pageLoading => _pageLoading;

  Future<void> fetchLeaderboardData() async {
    _isLoading = true;
    _currentPage = 1;
    notifyListeners();
    try {
      var res = await Userapi.getLeaderboard(_currentPage);
      if (res != null) {
        leaderboardData = res.leaderboardData ?? [];
        if (res.nextPageUrl != null) {
          _hasNext = true;
        } else {
          _hasNext = false;
        }
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
    _pageLoading = true;
    _currentPage++;
    notifyListeners();
    try {
      var res = await Userapi.getLeaderboard(_currentPage);
      if (res != null) {
        leaderboardData = res.leaderboardData ?? [];
        if (res.nextPageUrl != null) {
          _hasNext = true;
        } else {
          _hasNext = false;
        }
      } else {
        print("No leaderboard data found.");
      }
    } catch (e) {
    } finally {
      _pageLoading = false;
      notifyListeners();
    }
  }
}
