import 'package:flutter/material.dart';

import '../Services/UserApi.dart';
import '../model/GetFollowUpModel.dart';

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

  Future<void> getFollowUpApi() async {
    _isLoading = true;
    _currentPage = 1;
    notifyListeners();
    try {
      var result = await Userapi.getFollowup(_currentPage);
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

  Future<void> fetchMoreFollowUpList() async {
    _pageLoading = true;
    _currentPage++;
    notifyListeners();
    try {
      var result = await Userapi.getFollowup(_currentPage);
      if (result?.status == true) {
        _followuplist.addAll(result?.data?.followup_list ?? []);
        if(result?.data?.nextPageUrl!=null){
          _nextPage = true;
        }else{
          _nextPage = false;
        }
      } else {
        _followuplist = [];
        debugPrint("Failed to fetch followup list");
      }
    } catch (error) {
      debugPrint("Error fetching follow-up data: $error");
    } finally {
      _pageLoading = false;
      notifyListeners();
    }
  }


}
