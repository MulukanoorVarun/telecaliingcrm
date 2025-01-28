import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For ChangeNotifier
import '../Services/UserApi.dart';
import '../model/LeadsModel.dart';
import '../screens/SubscriptionExpiredScreen.dart';

class LeadsProvider with ChangeNotifier {
  List<Leads> leadslist=[];
  bool _isLoading = true;
  bool _hasNextPage = true;
  List<Leads>? get leadsList => leadslist;
  bool get isLoading => _isLoading;
  bool get hasNextPage => _hasNextPage;
  int _currentPage = 1; // Track the current page number
  int get currentPage => _currentPage;
  bool _pageLoading = false;  // Loading state
  bool get pageLoading => _pageLoading;


  Future<void> fetchLeadsList(type,BuildContext context) async {
    _isLoading = true;
    _currentPage = 1;
    leadslist =[];
    notifyListeners();
    try {
      var result = await Userapi.getLeads(type, _currentPage);
      if (result?.status == true) {
        leadslist = result?.data?.leadslist ?? [];
        if(result?.data?.nextPageUrl!=null){
          _hasNextPage = true;
          notifyListeners();
          print("fetchLeadsList Called  _hasNextPage = true;");
        }else{
          _hasNextPage = false;
          notifyListeners();
          print("fetchLeadsList Called  _hasNextPage = false");
        }
        notifyListeners();
      } else {
        Navigator.of(context)
            .push(PageRouteBuilder(
          pageBuilder: (context, animation,
              secondaryAnimation) {
            return SubscriptionExpiredScreen();
          },
          transitionsBuilder: (context,
              animation,
              secondaryAnimation,
              child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(
                begin: begin, end: end)
                .chain(CurveTween(
                curve: curve));
            var offsetAnimation =
            animation.drive(tween);
            return SlideTransition(
                position: offsetAnimation,
                child: child);
          },
        ));
        leadslist = result?.data?.leadslist ?? [];
        _hasNextPage = false;
      }
    } catch (e) {
      // If an error occurs, log or rethrow an exception
      print('Error fetching Leads list: $e');
      throw Exception('Failed to Leads list: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> fetchMoreLeadsList(String type, BuildContext context) async {
    if (!_hasNextPage || _pageLoading) {
      return;
    }
    _pageLoading = true;
    notifyListeners();

    try {
      var result = await Userapi.getLeads(type, _currentPage + 1);

      if (result?.status == true) {
        _currentPage++; // Increment the current page after a successful fetch.
        leadslist.addAll(result?.data?.leadslist ?? []);

        _hasNextPage = result?.data?.nextPageUrl != null; // Check for more pages.
      } else {
        _hasNextPage = false; // No more pages.
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return SubscriptionExpiredScreen();
            },
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween = Tween(begin: begin, end: end)
                  .chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
          ),
        );
      }
    } catch (e) {
      print('Error fetching more leads: $e');
    } finally {
      _pageLoading = false; // Reset loading state.
      notifyListeners();
    }
  }


  Future<bool?> AddleadsApi(name, mobile, date, remarks, leadStatus,BuildContext context) async {
    try {
      // Fetching user details from the API
      var response =
          await Userapi.postAddLeads(name, mobile, date, remarks, leadStatus);
      if (response != null) {
        if (response["status"] == true) {
          fetchLeadsList('',context);
          return response["status"];
        } else {
          return response["status"];
        }
      }
    } catch (e) {
      // If an error occurs, log or rethrow an exception
      print('Error adding lead: $e');
      throw Exception('Failed to add lead: $e');
    }
    return null;
  }

  Future<bool?> UpdateleadsApi(
      name, leadID, remarks, leadStatusID, leadStageID,BuildContext context) async {
    try {
      var response = await Userapi.postUpdateLeads(
        name,
        leadID,
        remarks,
        leadStatusID,
        leadStageID,
      );
      if (response != null) {
        if (response["status"] == true) {
          fetchLeadsList('',context);
          return response["status"];
        } else {
          return response["status"];
        }
      }
    } catch (e) {
      // If an error occurs, log or rethrow an exception
      print('Error updating user details: $e');
      throw Exception('Failed to updating user details: $e');
    }
    return null;
  }
}
