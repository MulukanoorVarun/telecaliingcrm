import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:telecaliingcrm/model/CallHistoryModel.dart';
import 'package:telecaliingcrm/model/DashBoardModel.dart';
import 'package:telecaliingcrm/model/LeadsModel.dart';
import 'package:telecaliingcrm/model/LeadeBoardModel.dart';
import 'package:telecaliingcrm/model/UserDetailsModel.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:telecaliingcrm/utils/constants.dart';
import '../model/ViewInfoModel.dart';
import '../model/GetFollowUpModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../utils/preferences.dart';
import 'AuthService.dart';
import 'package:logger/logger.dart';

class Userapi {
  static final Logger logger = Logger();
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://api.telecallingcrm.com",
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {"Content-Type": "application/json"},
    ),
  );

  static void setupInterceptors() {
    try {
      logger.d(
          "[UserApi] Setting up interceptors... NavigatorKey: $navigatorKey");
      logger.d(
          "[UserApi] Existing interceptors: ${_dio.interceptors.map((i) => i.runtimeType).toList()}");
      _dio.interceptors.clear();
      logger.d(
          "[UserApi] Cleared interceptors. Count: ${_dio.interceptors.length}");
      _dio.interceptors.add(LogInterceptor(
        request: kDebugMode,
        requestHeader: kDebugMode,
        requestBody: kDebugMode,
        responseHeader: kDebugMode,
        responseBody: kDebugMode,
        error: true,
      ));
      _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          logger.d("[Interceptor] Preparing request to: ${options.uri}");
          logger.d("[Interceptor] Headers before: ${options.headers}");
          try {
            final accessToken = await AuthService.getAccessToken();
            logger.d("[Interceptor] Access Token: $accessToken");
            if (accessToken != null && accessToken.isNotEmpty) {
              options.headers["Authorization"] = "Bearer $accessToken";
              logger.d(
                  "[Interceptor] Set Authorization: ${options.headers['Authorization']}");
            } else {
              logger.w("[Interceptor] No access token found");
            }
          } catch (e, stackTrace) {
            logger.e("[Interceptor] Error fetching token: $e");
            logger.e("[Interceptor] Stack trace: $stackTrace");
          }
          logger.d("[Interceptor] Final headers: ${options.headers}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          logger.d(
              "[Interceptor] Response from ${response.requestOptions.uri} - Status: ${response.statusCode}");
          _handleNavigation(response.statusCode, navigatorKey);
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          logger.e("[Interceptor] Error: ${e.message}");
          if (e.response != null) {
            logger.e(
                "[Interceptor] Status: ${e.response?.statusCode}, Data: ${e.response?.data}");
            _handleNavigation(e.response?.statusCode, navigatorKey);
          }
          return handler.next(e);
        },
      ));
      logger.d("[UserApi] Interceptors added: ${_dio.interceptors.length}");
    } catch (e, stackTrace) {
      logger.e("[UserApi] Error setting up interceptors: $e");
      logger.e("[UserApi] Stack trace: $stackTrace");
    }
  }

  static Future<Response> post(String path,
      {dynamic data, Options? options}) async {
    logger.d("[API] POST $path");
    logger.d("[API] Interceptor count: ${_dio.interceptors.length}");
    try {
      return await _dio.post(path, data: data, options: options);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters, Options? options}) async {
    logger.d("[API] GET $path");
    logger.d("[API] Interceptor count: ${_dio.interceptors.length}");
    try {
      return await _dio.get(path,
          queryParameters: queryParameters, options: options);
    } catch (e) {
      return _handleError(e);
    }
  }

  static void _handleNavigation(
      int? statusCode, GlobalKey<NavigatorState> navigatorKey) async {
    if (statusCode == null) return;

    switch (statusCode) {
      case 401:
        logger.w("Unauthorized: Navigating to SignIn");
        PreferenceService().remove("token");
        Future.microtask(() {
          navigatorKey.currentState
              ?.pushNamedAndRemoveUntil('/signin', (route) => false);
        });
        break;
      case 403:
        logger
            .w("Subscription expired: Navigating to SubscriptionExpiredScreen");
        PreferenceService().remove("token");
        Future.microtask(() {
          navigatorKey.currentState
              ?.pushNamedAndRemoveUntil('/subscribe', (route) => false);
        });
        break;

      case 429:
        logger.w("Too many requests: Navigating to TooManyRequestsScreen");
        Future.microtask(() {
          navigatorKey.currentState
              ?.pushNamedAndRemoveUntil('/toomanyrequests', (route) => false);
        });
        break;

      default:
        logger.d("Unhandled status code: $statusCode");
    }
  }

  static Future<Response> _handleError(dynamic e) async {
    logger.e("[API] Error: $e");
    return Future.error(e);
  }

  static Future<Map<String, dynamic>?> postSignIn(
      String email, String pwd) async {
    try {
      final data = {
        "email": email,
        "password": pwd,
      };
      final response = await post("/api/login", data: data);

      if (response.data == null || response.data.isEmpty) {
        debugPrint("Empty response body.");
        return null;
      }

      debugPrint("Request successful: ${response.data}");
      return response.data;
    } catch (e) {
      debugPrint("Error occurred: $e");
      return null;
    }
  }

  static Future<DashBoardModel?> dashboardApi() async {
    try {
      final token = await AuthService.getAccessToken();
      logger.d("[dashboardApi] Using token: $token");
      final response = await post("/api/dashboard");
      if (response.statusCode == 200 && response.data != null) {
        logger.d("dashboardApi response: ${response.data}");
        return DashBoardModel.fromJson(response.data);
      }
      logger.d(
          "Request failed with status: ${response.statusCode}, bloc: ${response.data}");
      return null;
    } catch (e) {
      logger.e("Error occurred in dashboardApi: $e");
      if (e is DioException && e.response != null) {
        logger.e("Response bloc: ${e.response?.data}");
      }
      return null;
    }
  }

  static Future<UserDetailsModel?> getUserDetails() async {
    try {
      final response = await post("/api/profile");
      if (response.statusCode == 200) {
        debugPrint("getUserDetails response: ${response.data}");
        return UserDetailsModel.fromJson(response.data);
      }
      debugPrint("Request failed with status: ${response.statusCode}");
      return null;
    } catch (e) {
      debugPrint("Error occurred in getUserDetails: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> updateCallStatusApi(
      String id, String callStatus, String callDuration) async {
    try {
      final data = {
        "id": id,
        "call_status": callStatus,
        "call_duration": callDuration,
      };
      debugPrint("updateCallStatusApi bloc: $data");
      final response = await post("/api/update_call_status_api", data: data);

      if (response.statusCode == 200) {
        debugPrint("Request successful: ${response.data}");
        return response.data;
      }
      debugPrint(
          "Request failed with status: ${response.statusCode}, body: ${response.data}");
      return null;
    } catch (e) {
      debugPrint("Error occurred: $e");
      return null;
    }
  }

  static Future<LeadsModel?> getLeads(String type, int page) async {
    try {
      final response = await get(
        "/api/get_lead_calls",
        queryParameters: {
          "stagename": type,
          "page": page.toString(),
        },
      );
      if (response.statusCode == 200) {
        debugPrint("getLeads response: ${response.data}");
        return LeadsModel.fromJson(response.data);
      }
      debugPrint("Request failed with status: ${response.statusCode}");
      return null;
    } catch (e) {
      debugPrint("Error occurred in getLeads: $e");
      return null;
    }
  }

  static Future<CallHistoryModel?> getCallHistory(String date, int page) async {
    try {
      final token = await AuthService.getAccessToken();
      if (token == null) {
        debugPrint("Error: No access token available");
        return null;
      }

      final response = await get(
        "/api/today-called-history",
        queryParameters: {
          "latest_update": date,
          "page": page.toString(),
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        debugPrint("getCallHistory response: ${response.data}");
        return CallHistoryModel.fromJson(response.data);
      }
      debugPrint("Request failed with status: ${response.statusCode}");
      return null;
    } catch (e) {
      debugPrint("Error occurred: $e");
      return null;
    }
  }

  static Future<LeaderBoardModel?> getLeaderboard(int currentPage) async {
    try {
      final token = await AuthService.getAccessToken();
      if (token == null) {
        debugPrint("Error: No access token available");
        return null;
      }

      final response = await post(
        "/api/get_leader_board",
        data: {"page": currentPage.toString()},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        debugPrint("getLeaderboard response: ${response.data}");
        return LeaderBoardModel.fromJson(response.data);
      }
      debugPrint("Request failed with status: ${response.statusCode}");
      return null;
    } catch (e) {
      debugPrint("Error occurred: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> postAddLeads(String name, String num,
      String followupDate, String remarks, String leadId) async {
    try {
      final data = {
        "name": name,
        "number": num,
        "followup_date": followupDate,
        "remarks": remarks,
        "lead_stage_id": leadId,
      };
      debugPrint("postAddLeads??$data");
      final response = await post("/api/add-lead", data: data);

      if (response.data == null || response.data.isEmpty) {
        debugPrint("Empty response body.");
        return null;
      }

      debugPrint("postAddLeads successful: ${response.data}");
      return response.data;
    } catch (e) {
      debugPrint("Error occurred: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> postAddFollowUp(
      String leadId, String name, String followupDate, String remarks) async {
    try {
      final data = {
        "lead_id": leadId,
        "name": name,
        "followup_date": followupDate,
        "remarks": remarks,
      };
      debugPrint("postAddFollowUp??$data");
      final response = await post("/api/add-follow-up", data: data);

      if (response.data == null || response.data.isEmpty) {
        debugPrint("Empty response body.");
        return null;
      }

      debugPrint("postAddFollowUp successful: ${response.data}");
      return response.data;
    } catch (e) {
      debugPrint("Error occurred: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> postUpdateLeads(
      String name,
      String leadId,
      String remarks,
      String leadStageId,
      String dealStage) async {
    try {
      final data = {
        "name": name,
        "lead_id": leadId,
        "remarks": remarks,
        "lead_stage_id": leadStageId,
        "deal_stage": dealStage,
      };
      debugPrint("postUpdateLeads??$data");
      final response = await post("/api/update-info", data: data);

      if (response.data == null || response.data.isEmpty) {
        debugPrint("Empty response body.");
        return null;
      }

      debugPrint("postUpdateLeads successful: ${response.data}");
      return response.data;
    } catch (e) {
      debugPrint("Error occurred: $e");
      return null;
    }
  }

  static Future<ViewInfoModel?> getViewInfo(String id) async {
    try {
      final response = await get("/api/view-info/$id");

      if (response.statusCode == 200) {
        debugPrint("getViewInfo response: ${response.data}");
        return ViewInfoModel.fromJson(response.data);
      }
      debugPrint("Request failed with status: ${response.statusCode}");
      return null;
    } catch (e) {
      debugPrint("Error occurred: $e");
      return null;
    }
  }

  static Future<GetFollowUpModel?> getFollowup(int page) async {
    try {
      final response = await get(
        "/api/follow_up_list",
        queryParameters: {"page": page.toString()},
      );

      if (response.statusCode == 200) {
        debugPrint("getFollowup response: ${response.data}");
        return GetFollowUpModel.fromJson(response.data);
      }
      debugPrint("Request failed with status: ${response.statusCode}");
      return null;
    } catch (e) {
      debugPrint("Error occurred in getFollowup: $e");
      return null;
    }
  }

  static Future<String?> updateProfile(
      String userId, String fullname, String email, File? image) async {
    try {
      final formData = FormData.fromMap({
        "username": fullname,
        "email": email,
      });

      if (image != null) {
        final mimeType = lookupMimeType(image.path);
        if (mimeType != null && mimeType.startsWith('image/')) {
          formData.files.add(MapEntry(
            "photo",
            await MultipartFile.fromFile(
              image.path,
              contentType: MediaType.parse(mimeType),
            ),
          ));
        } else {
          debugPrint("Invalid image file");
          return null;
        }
      }

      final response =
          await post("/api/update-profile/$userId", data: formData);

      if (response.statusCode == 200) {
        if (response.data['message'] == 'User updated successfully') {
          return 'Profile updated successfully.';
        }
        return 'Profile update failed: ${response.data['message']}';
      }
      return 'Error: ${response.statusCode}';
    } catch (e) {
      debugPrint("Error occurred: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> updateRefreshToken() async {
    try {
      final response = await post("/api/refresh-token");

      if (response.data == null || response.data.isEmpty) {
        debugPrint("Empty response body.");
        return null;
      }

      debugPrint("Request successful: ${response.data}");
      return response.data;
    } catch (e) {
      debugPrint("Error occurred: $e");
      return null;
    }
  }

  static Future<bool?> updatePassword(
      String email, String password, BuildContext context) async {
    try {
      final response = await post(
        "/api/update_password",
        data: {
          "email": email,
          "password": password,
        },
      );

      if (response.statusCode == 200 && response.data['status']) {
        CustomSnackBar.show(context, response.data['message']);
        return true;
      }
      CustomSnackBar.show(
          context, response.data['message'] ?? "Error updating password");
      return false;
    } catch (e) {
      debugPrint("Error occurred: $e");
      return null;
    }
  }

  static Future<bool?> forgetPassword(
      String email, BuildContext context) async {
    try {
      final response = await post(
        "/api/forget-password",
        data: {"email": email},
      );

      if (response.statusCode == 200) {
        CustomSnackBar.show(context, response.data['message']);
        return true;
      } else if (response.statusCode == 400) {
        CustomSnackBar.show(
            context, response.data['email']?[0] ?? "An error occurred.");
        return false;
      }
      CustomSnackBar.show(context, "Unexpected error: ${response.statusCode}");
      return false;
    } catch (e) {
      debugPrint("Error occurred: $e");
      CustomSnackBar.show(context, "An error occurred. Please try again.");
      return null;
    }
  }

  static Future<bool?> forgetPasswordOtpVerify(
      String email, String otp, BuildContext context) async {
    try {
      final response = await post(
        "/api/verify-otp",
        data: {
          "email": email,
          "otp": otp,
        },
      );

      if (response.statusCode == 200) {
        CustomSnackBar.show(context, response.data['message']);
        return true;
      }
      CustomSnackBar.show(context, response.data['message'] ?? "Invalid OTP");
      return false;
    } catch (e) {
      debugPrint("Error occurred: $e");
      return null;
    }
  }
}
