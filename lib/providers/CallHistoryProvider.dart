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

  Future<void> getCallHistoryApi() async {
    _loading = true;
    _currentPage = 1;
    notifyListeners();
    try {
      var res = await Userapi.getCallHistory(_currentPage);
      if (res != null) {
        call_history = res.data?.call_history??[];
        if (res.data?.nextPageUrl != null) {
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

  Future<void> getMoreCallHistoryApi() async {
    _pageLoading = true;
    _currentPage++;
    try {
      var res = await Userapi.getCallHistory(_currentPage);
      if (res != null) {
        call_history = res.data?.call_history??[];
        if (res.data?.nextPageUrl != null) {
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
      _pageLoading = false;
      notifyListeners();
    }
  }
}
