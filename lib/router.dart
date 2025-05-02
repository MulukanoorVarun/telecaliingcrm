import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:telecaliingcrm/screens/AddFollowUp.dart';
import 'package:telecaliingcrm/screens/AddLeadsScreen.dart';
import 'package:telecaliingcrm/screens/CallHistoryScreen.dart';
import 'package:telecaliingcrm/screens/Edit%20Profile%20screeen.dart';
import 'package:telecaliingcrm/screens/FolloupInformation.dart';
import 'package:telecaliingcrm/screens/FollowupsScreen.dart';
import 'package:telecaliingcrm/screens/LeadInformation.dart';
import 'package:telecaliingcrm/screens/LeadsScreen.dart';
import 'package:telecaliingcrm/screens/LostLeadScreen.dart';
import 'package:telecaliingcrm/screens/OnBoardingScreen.dart';
import 'package:telecaliingcrm/screens/PermissionScreen.dart';
import 'package:telecaliingcrm/screens/SpalshScreen.dart';
import 'package:telecaliingcrm/screens/UpDateLeadScreen.dart';
import 'package:telecaliingcrm/screens/UpdateFollowUp.dart';
import 'package:telecaliingcrm/screens/dashboard.dart';
import 'package:telecaliingcrm/screens/widgets/NoInternet.dart';
import 'package:telecaliingcrm/utils/constants.dart';

import 'Authentication/SignInScreen.dart';

final GoRouter goRouter =
    GoRouter(initialLocation: '/', navigatorKey: navigatorKey, routes: [
  GoRoute(
    path: '/',
    pageBuilder: (context, state) {
      return buildSlideTransitionPage(Splash(), state);
    },
  ),
  GoRoute(
    path: '/on_board',
    pageBuilder: (context, state) {
      return buildSlideTransitionPage(OnBoardindScreen(), state);
    },
  ),
  GoRoute(
    path: '/permission',
    pageBuilder: (context, state) {
      return buildSlideTransitionPage(PermissionScreen(), state);
    },
  ),
  GoRoute(
    path: '/signin',
    pageBuilder: (context, state) {
      return buildSlideTransitionPage(SignInScreen(), state);
    },
  ),
  GoRoute(
    path: '/dashboard',
    pageBuilder: (context, state) {
      return buildSlideTransitionPage(Dashboard(), state);
    },
  ),
  GoRoute(
    path: '/leads',
    pageBuilder: (context, state) {
      return buildSlideTransitionPage(LeadScreen(), state);
    },
  ),
  GoRoute(
    path: '/followups',
    pageBuilder: (context, state) {
      return buildSlideTransitionPage(FollowupsScreen(), state);
    },
  ),
  GoRoute(
    path: '/update_lead',
    pageBuilder: (context, state) {
      final id = state.uri.queryParameters['ID'] ?? '';
      final name = state.uri.queryParameters['name'] ?? '';
      final remarks = state.uri.queryParameters['remarks'] ?? '';
      return buildSlideTransitionPage(
          UpDateLeadScreen(ID: id, name: name, remarks: remarks), state);
    },
  ),
  GoRoute(
    path: '/lead_information',
    pageBuilder: (context, state) {
      final id = state.uri.queryParameters['ID'] ?? '';
      return buildSlideTransitionPage(LeadInformation(ID: id), state);
    },
  ),
  GoRoute(
    path: '/edit_profile',
    pageBuilder: (context, state) {
      return buildSlideTransitionPage(EditProfileScreen(), state);
    },
  ),
  GoRoute(
    path: '/call_history',
    pageBuilder: (context, state) {
      final date = state.uri.queryParameters['date'] ?? '';
      final type = state.uri.queryParameters['type'] ?? '';
      return buildSlideTransitionPage(
          Callhistoryscreen(date: date, type: type), state);
    },
  ),
  GoRoute(
    path: '/add_lead',
    pageBuilder: (context, state) {
      return buildSlideTransitionPage(Addleadsscreen(), state);
    },
  ),
  GoRoute(
    path: '/no_internet',
    pageBuilder: (context, state) {
      return buildSlideTransitionPage(Nointernet(), state);
    },
  ),
  GoRoute(
    path: '/add_followup',
    pageBuilder: (context, state) {
      final id = state.uri.queryParameters['id'] ?? '';
      final name = state.uri.queryParameters['name'] ?? '';
      return buildSlideTransitionPage(AddFollowUp(id: id, name: name), state);
    },
  ),
  GoRoute(
    path: '/update_lead',
    pageBuilder: (context, state) {
      final id = state.uri.queryParameters['ID'] ?? '';
      final name = state.uri.queryParameters['name'] ?? '';
      final remarks = state.uri.queryParameters['remarks'] ?? '';
      return buildSlideTransitionPage(
          UpDateLeadScreen(
            ID: id,
            name: name,
            remarks: remarks,
          ),
          state);
    },
  ),
  GoRoute(
    path: '/lost_lead',
    pageBuilder: (context, state) {
      final id = state.uri.queryParameters['id'] ?? '';
      final name = state.uri.queryParameters['name'] ?? '';
      final remarks = state.uri.queryParameters['remarks'] ?? '';
      final dealStage = state.uri.queryParameters['dealStage'] ?? '';
      final leadsStage = state.uri.queryParameters['leadsStage'] ?? '';
      return buildSlideTransitionPage(
          LostLeadScreen(
            ID: id,
            name: name,
            remarks: remarks,dealStage:dealStage ,leadsStage: leadsStage,
          ),
          state);
    },
  ),
  GoRoute(
    path: '/update_followup',
    pageBuilder: (context, state) {
      final type = state.uri.queryParameters['type'] ?? '';
      final folloupId = state.uri.queryParameters['folloupId'] ?? '';
      final leadId = state.uri.queryParameters['leadId'] ?? '';
      final staffId = state.uri.queryParameters['staffId'] ?? '';
      return buildSlideTransitionPage(
          UpdateFollowupScreen(
            folloupId: folloupId,
            leadId: leadId,
            type: type,
            staffId: staffId,
          ),
          state);
    },
  ),
  GoRoute(
    path: '/followup_information',
    pageBuilder: (context, state) {
      final leadId = state.uri.queryParameters['leadId'] ?? '';
      final followupId = state.uri.queryParameters['followupId'] ?? '';
      return buildSlideTransitionPage(
          FollowupInformation(leadId: leadId, followupId: followupId), state);
    },
  ),
]);

Page<dynamic> buildSlideTransitionPage(Widget child, GoRouterState state) {
  if (Platform.isIOS) {
    return CupertinoPage(key: state.pageKey, child: child);
  }
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
