import 'dart:io';
import 'package:flutter/cupertino.dart';
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
import './ApiClient.dart';


class Userapi {
  static Future<Map<String, dynamic>?> postSignIn(String email, String pwd) async {
    try {
      final data = {
        "email": email,
        "password": pwd,
      };
      final response = await ApiClient.post(
        "/api/login",
        data: data,
      );

      if (response.data == null || response.data.isEmpty) {
        print("Empty response body.");
        return null;
      }

      print("Request successful: ${response.data}");
      return response.data;
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
  }

  static Future<DashBoardModel?> dashboardApi() async {
    try {
      final response = await ApiClient.post("/api/dashboard");
      if (response.statusCode == 200) {
        print("dashboardApi response: ${response.data}");
        return DashBoardModel.fromJson(response.data);
      }
      print("Request failed with status: ${response.statusCode}");
      return null;
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
  }

  static Future<UserDetailsModel?> getUserDetails() async {
    try {
      final response = await ApiClient.post("/api/profile");

      if (response.statusCode == 200) {
        print("getUserDetails response: ${response.data}");
        return UserDetailsModel.fromJson(response.data);
      }
      print("Request failed with status: ${response.statusCode}");
      return null;
    } catch (e) {
      print("Error occurred in getUserDetails: $e");
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
      print("updateCallStatusApi data: $data");
      final response = await ApiClient.post(
        "/api/update_call_status_api",
        data: data,
      );

      if (response.statusCode == 200) {
        print("Request successful: ${response.data}");
        return response.data;
      }
      print(
          "Request failed with status: ${response.statusCode}, body: ${response.data}");
      return null;
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
  }

  static Future<LeadsModel?> getLeads(String type, int page) async {
    try {
      final response = await ApiClient.get(
        "/api/get_lead_calls",
        queryParameters: {
          "stagename": type,
          "page": page.toString(),
        },
      );

      if (response.statusCode == 200) {
        print("getLeads response: ${response.data}");
        return LeadsModel.fromJson(response.data);
      }
      print("Request failed with status: ${response.statusCode}");
      return null;
    } catch (e) {
      print("Error occurred in getLeads: $e");
      return null;
    }
  }

  static Future<LeaderBoardModel?> getLeaderboard(int currentPage) async {
    try {
      final response = await ApiClient.post(
        "/api/get_leader_board",
        data: {"page": currentPage.toString()},
      );

      if (response.statusCode == 200) {
        print("getLeaderboard response: ${response.data}");
        return LeaderBoardModel.fromJson(response.data);
      }
      print("Request failed with status: ${response.statusCode}");
      return null;
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> postAddLeads(
      String name, String num, String followupDate, String remarks, String leadId) async {
    try {
      final data = {
        "name": name,
        "number": num,
        "followup_date": followupDate,
        "remarks": remarks,
        "lead_stage_id": leadId,
      };
      print("postAddLeads??$data");
      final response = await ApiClient.post(
        "/api/add-lead",
        data: data,
      );

      if (response.data == null || response.data.isEmpty) {
        print("Empty response body.");
        return null;
      }

      print("postAddLeads successful: ${response.data}");
      return response.data;
    } catch (e) {
      print("Error occurred: $e");
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
      print("postAddFollowUp??$data");
      final response = await ApiClient.post(
        "/api/add-follow-up",
        data: data,
      );

      if (response.data == null || response.data.isEmpty) {
        print("Empty response body.");
        return null;
      }

      print("postAddFollowUp successful: ${response.data}");
      return response.data;
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> postUpdateLeads(
      String name, String leadId, String remarks, String leadStageId, String dealStage) async {
    try {
      final data = {
        "name": name,
        "lead_id": leadId,
        "remarks": remarks,
        "lead_stage_id": leadStageId,
        "deal_stage": dealStage,
      };
      print("postUpdateLeads??$data");
      final response = await ApiClient.post(
        "/api/update-info",
        data: data,
      );

      if (response.data == null || response.data.isEmpty) {
        print("Empty response body.");
        return null;
      }

      print("postUpdateLeads successful: ${response.data}");
      return response.data;
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
  }

  static Future<ViewInfoModel?> getViewInfo(String id) async {
    try {
      final response = await ApiClient.get("/api/view-info/$id");

      if (response.statusCode == 200) {
        print("getViewInfo response: ${response.data}");
        return ViewInfoModel.fromJson(response.data);
      }
      print("Request failed with status: ${response.statusCode}");
      return null;
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
  }

  static Future<GetFollowUpModel?> getFollowup(int page) async {
    try {
      final response = await ApiClient.get(
        "/api/follow_up_list",
        queryParameters: {"page": page.toString()},
      );

      if (response.statusCode == 200) {
        print("getFollowup response: ${response.data}");
        return GetFollowUpModel.fromJson(response.data);
      }
      print("Request failed with status: ${response.statusCode}");
      return null;
    } catch (e) {
      print("Error occurred in getFollowup: $e");
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
          print("Invalid image file");
          return null;
        }
      }

      final response = await ApiClient.post(
        "/api/update-profile/$userId",
        data: formData,
      );

      if (response.statusCode == 200) {
        if (response.data['message'] == 'User updated successfully') {
          return 'Profile updated successfully.';
        }
        return 'Profile update failed: ${response.data['message']}';
      }
      return 'Error: ${response.statusCode}';
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> updateRefreshToken() async {
    try {
      final response = await ApiClient.post("/api/refresh-token");

      if (response.data == null || response.data.isEmpty) {
        print("Empty response body.");
        return null;
      }

      print("Request successful: ${response.data}");
      return response.data;
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
  }

  static Future<CallHistoryModel?> getCallHistory(String date, int page) async {
    try {
      final response = await ApiClient.get(
        "/api/today-called-history",
        queryParameters: {
          "latest_update": date,
          "page": page.toString(),
        },
      );

      if (response.statusCode == 200) {
        print("getCallHistory response: ${response.data}");
        return CallHistoryModel.fromJson(response.data);
      }
      print("Request failed with status: ${response.statusCode}");
      return null;
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
  }

  static Future<bool?> updatePassword(String email, String password, BuildContext context) async {
    try {
      final response = await ApiClient.post(
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
      CustomSnackBar.show(context, response.data['message'] ?? "Error updating password");
      return false;
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
  }

  static Future<bool?> forgetPassword(String email, BuildContext context) async {
    try {
      final response = await ApiClient.post(
        "/api/forget-password",
        data: {"email": email},
      );

      if (response.statusCode == 200) {
        CustomSnackBar.show(context, response.data['message']);
        return true;
      } else if (response.statusCode == 400) {
        CustomSnackBar.show(context, response.data['email']?[0] ?? "An error occurred.");
        return false;
      }
      CustomSnackBar.show(context, "Unexpected error: ${response.statusCode}");
      return false;
    } catch (e) {
      print("Error occurred: $e");
      CustomSnackBar.show(context, "An error occurred. Please try again.");
      return null;
    }
  }

  static Future<bool?> forgetPasswordOtpVerify(String email, String otp, BuildContext context) async {
    try {
      final response = await ApiClient.post(
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
      print("Error occurred: $e");
      return null;
    }
  }
}
