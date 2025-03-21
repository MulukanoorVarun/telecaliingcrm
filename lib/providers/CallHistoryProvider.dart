import 'package:flutter/cupertino.dart';
import 'package:telecaliingcrm/model/CallHistoryModel.dart';
import 'package:telecaliingcrm/services/UserApi.dart';

import '../screens/SubscriptionExpiredScreen.dart';

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

  Future<void> getCallHistoryApi(date,BuildContext context) async {
    _loading = true;
    _currentPage = 1;
    notifyListeners();
    try {
      var res = await Userapi.getCallHistory(date,_currentPage,context);
      if (res?.status==true) {
        call_history = res?.data?.call_history??[];
        // Update `_hasNext` based on the API response
        _hasNext = res?.data?.nextPageUrl != null;
      } else {
        // Navigator.of(context)
        //     .push(PageRouteBuilder(
        //   pageBuilder: (context, animation,
        //       secondaryAnimation) {
        //     return SubscriptionExpiredScreen();
        //   },
        //   transitionsBuilder: (context,
        //       animation,
        //       secondaryAnimation,
        //       child) {
        //     const begin = Offset(1.0, 0.0);
        //     const end = Offset.zero;
        //     const curve = Curves.easeInOut;
        //     var tween = Tween(
        //         begin: begin, end: end)
        //         .chain(CurveTween(
        //         curve: curve));
        //     var offsetAnimation =
        //     animation.drive(tween);
        //     return SlideTransition(
        //         position: offsetAnimation,
        //         child: child);
        //   },
        // ));
        debugPrint("No data received");
        _hasNext = false;
      }
    } catch (e) {
      debugPrint("Error in GetCallHistoryApi: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> getMoreCallHistoryApi(date,BuildContext context) async {
    // Prevent redundant calls if no more pages or a fetch is already in progress
    if (!_hasNext || _pageLoading) {
      debugPrint("No more pages to fetch or another fetch is in progress.");
      return;
    }

    _pageLoading = true; // Mark as loading
    notifyListeners();

    try {
      debugPrint("Fetching page $_currentPage...");
      var res = await Userapi.getCallHistory(date,_currentPage + 1,context); // Increment the page for API call

      if (res?.status == true) {
        _currentPage++; // Increment page count after successful fetch

        call_history.addAll(res?.data?.call_history ?? []); // Append new call history

        // Update `_hasNext` based on the API response
        _hasNext = res?.data?.nextPageUrl != null;

        debugPrint(_hasNext
            ? "Next page available, more data to fetch."
            : "No more pages to fetch.");
      } else {
        // Navigator.of(context)
        //     .push(PageRouteBuilder(
        //   pageBuilder: (context, animation,
        //       secondaryAnimation) {
        //     return SubscriptionExpiredScreen();
        //   },
        //   transitionsBuilder: (context,
        //       animation,
        //       secondaryAnimation,
        //       child) {
        //     const begin = Offset(1.0, 0.0);
        //     const end = Offset.zero;
        //     const curve = Curves.easeInOut;
        //     var tween = Tween(
        //         begin: begin, end: end)
        //         .chain(CurveTween(
        //         curve: curve));
        //     var offsetAnimation =
        //     animation.drive(tween);
        //     return SlideTransition(
        //         position: offsetAnimation,
        //         child: child);
        //   },
        // ));
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
