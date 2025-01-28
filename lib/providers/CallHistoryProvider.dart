import 'package:flutter/cupertino.dart';
import 'package:telecaliingcrm/model/CallHistoryModel.dart';
import 'package:telecaliingcrm/services/UserApi.dart';

class CallHistoryProvider extends ChangeNotifier {
  bool _loading = false;
  List<CallHistory> call_history = [];
  bool get loading => _loading;
  int _currentPage = 1;
  int get currentPage => _currentPage;
  bool _hasNext = true;
  bool get hasNext => _hasNext;
  bool _pageLoading = false;
  bool get pageLoading => _pageLoading;

  Future<void> getCallHistoryApi(BuildContext context) async {
    _loading = true;
    _currentPage = 1;
    notifyListeners();
    try {
      var res = await Userapi.getCallHistory(_currentPage);
      if (res?.status==true) {
        call_history = res?.data?.call_history??[];
        if (res?.data?.nextPageUrl != null) {
          _hasNext = true;
        } else {
          _hasNext = false;
        }
      } else {
        debugPrint("No data received");
      }
    } catch (e) {
      debugPrint("Error in GetCallHistoryApi: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> getMoreCallHistoryApi(BuildContext context) async {
    // Prevent redundant calls if no more pages or a fetch is already in progress
    if (!_hasNext || _pageLoading) {
      debugPrint("No more pages to fetch or another fetch is in progress.");
      return;
    }

    _pageLoading = true; // Mark as loading
    notifyListeners();

    try {
      debugPrint("Fetching page $_currentPage...");
      var res = await Userapi.getCallHistory(_currentPage + 1); // Increment the page for API call

      if (res?.status == true) {
        _currentPage++; // Increment page count after successful fetch

        call_history.addAll(res?.data?.call_history ?? []); // Append new call history

        // Update `_hasNext` based on the API response
        _hasNext = res?.data?.nextPageUrl != null;

        debugPrint(_hasNext
            ? "Next page available, more data to fetch."
            : "No more pages to fetch.");
      } else {
        debugPrint("API returned failure status. No data received.");
      }
    } catch (e) {
      // Log errors
      debugPrint("Error in GetCallHistoryApi: $e");
    } finally {
      _pageLoading = false; // Reset loading state
      notifyListeners();    // Notify listeners of the state change
    }
  }

}
