import 'package:flutter/cupertino.dart';
import 'package:telecaliingcrm/model/CallHistoryModel.dart';
import 'package:telecaliingcrm/services/UserApi.dart';

import '../screens/SubscriptionExpiredScreen.dart';

class CallHistoryProvider extends ChangeNotifier {
  bool _loading = false;
  List<CallHistoryItem> call_history = [];
  bool get loading => _loading;
  int _currentPage = 1;
  int get currentPage => _currentPage;
  bool _hasNext = true;
  bool get hasNext => _hasNext;
  bool _pageLoading = false;
  bool get pageLoading => _pageLoading;

  Future<bool?> getCallHistoryApi(date,String call_status) async {
    _loading = true;
    _currentPage = 1;
    notifyListeners();
    try {
      var res = await Userapi.getCallHistory(date,call_status, _currentPage);
      if (res != null) {
        call_history = res.data ?? [];
        _hasNext = res.nextPageUrl != null;
        return true;
      } else {
        debugPrint("No bloc received");
        _hasNext = false;
        return false;
      }
    } catch (e) {
      debugPrint("Error in GetCallHistoryApi: $e");
    } finally {
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool?> getMoreCallHistoryApi(date,String call_status) async {
    // Prevent redundant calls if no more pages or a fetch is already in progress
    if (!_hasNext || _pageLoading) {
      debugPrint("No more pages to fetch or another fetch is in progress.");
      return null; // <-- FIXED
    }
    _pageLoading = true; // Mark as loading
    notifyListeners();

    try {
      debugPrint("Fetching page $_currentPage...");
      var res = await Userapi.getCallHistory(
          date,call_status, _currentPage + 1); // Increment the page for API call
      if (res != null) {
        _currentPage++;
        call_history.addAll(res.data ?? []);
        _hasNext = res.nextPageUrl != null;
        debugPrint(_hasNext
            ? "Next page available, more bloc to fetch."
            : "No more pages to fetch.");
        return true;
      } else {
        debugPrint("API returned failure status. No bloc received.");
        return true;
      }
    } catch (e) {
      // Log errors
      debugPrint("Error in GetCallHistoryApi: $e");
    } finally {
      _pageLoading = false; // Reset loading state
      notifyListeners(); // Notify listeners of the state change
      return true;
    }
  }
}
