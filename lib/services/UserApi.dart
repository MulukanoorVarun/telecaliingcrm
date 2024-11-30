import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:telecaliingcrm/model/DashBoardModel.dart';
import 'package:telecaliingcrm/model/LeadsModel.dart';
import 'package:telecaliingcrm/model/LeadeBoardModel.dart';
import 'package:telecaliingcrm/model/UserDetailsModel.dart';
import 'package:telecaliingcrm/services/otherservices.dart';

import '../model/ViewInfoModel.dart';

import '../model/GetFollowUpModel.dart';

class Userapi {
  static String host = "https://api.telecallingcrm.com";

  static Future<Map<String, dynamic>?> PostSignIn(
      String email, String pwd) async {
    try {
      // Prepare the request data
      Map<String, String> data = {
        "email": email,
        "password": pwd,
      };
      final url = Uri.parse("${host}/api/login");
      final response = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: jsonEncode(data),
      );

      // Check if the response body is empty
      if (response.body.isEmpty) {
        print("Empty response body.");
        return null;
      }

      // Parse the response body
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Success: Return the parsed response
        print("Request successful: $jsonResponse");
        return jsonResponse;
      } else {
        // Handle other status codes and return the response
        print(
            "Request failed with status: ${response.statusCode}, body: $jsonResponse");
        return jsonResponse;
      }
    } catch (e) {
      // Catch and log any errors
      print("Error occurred: $e");
      return null;
    }
  }

  static Future<DashBoardModel?> DahsBoardApi() async {
    try {
      final url = Uri.parse("${host}/api/dashboard");
      final headers = await getheader1(); // Await the result here
      final response = await http.post(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("DahsBoardApi response: ${response.body}");

        // Parse the JSON response into a model
        return DashBoardModel.fromJson(jsonResponse);
      } else {
        // Handle non-200 responses (e.g., 401, 404, etc.)
        print("Request failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      // Catch and log any errors
      print("Error occurred: $e");
      return null;
    }
  }

  static Future<UserDetailsModel?> getUserDetails() async {
    try {
      final url = Uri.parse("${host}/api/profile");
      final headers = await getheader1();
      final response = await http.post(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("getUserDetails response: ${response.body}");

        return UserDetailsModel.fromJson(jsonResponse);
      } else {
        print("Request failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      // Log any errors
      print("Error occurred in getUserDetails: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> UpdateCallStatusApi(
      String id, String call_status, String call_duration) async {
    try {
      // Prepare the request data
      Map<String, String> data = {
        "id": id,
        "call_status": call_status,
        "call_duration": call_duration
      };

      print("UpdateCallStatusApi data: $data");

      final url = Uri.parse("${host}/api/update_call_status_api");
      final headers =
          await getheader1(); // Ensure this function returns the correct headers

      final response = await http.post(
        url,
        headers: headers,
        body: data,
      );

      // Check if the status code is 200
      if (response.statusCode == 200) {
        try {
          // Try decoding the response body to JSON
          final jsonResponse = jsonDecode(response.body);
          print("Request successful: $jsonResponse");
          return jsonResponse;
        } catch (e) {
          // Handle the case where the response is not valid JSON
          print(
              "Error: Failed to decode response body. Response: ${response.body}");
          return null;
        }
      } else {
        // Log the response status code and body if it's not 200
        print(
            "Request failed with status: ${response.statusCode}, body: ${response.body}");
        return null;
      }
    } catch (e) {
      // Catch and log any errors during the request
      print("Error occurred: $e");
      return null;
    }
  }

  static Future<LeadsModel?> getLeads() async {
    try {
      final url = Uri.parse("${host}/api/get_lead_calls");
      final headers = await getheader1();
      final response = await http.post(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("getLeads response: ${response.body}");
        return LeadsModel.fromJson(jsonResponse);
      } else {
        print("Request failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      // Log any errors
      print("Error occurred in getUserDetails: $e");
      return null;
    }
  }

  static Future<List<LeaderBoardModel>?> getLeaderboard() async {
    try {
      final url = Uri.parse("${host}/api/get_leader_board");
      final headers = await getheader1();
      final response = await http.post(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("getLeaderboard response: ${response.body}");

        if (jsonResponse is List) {
          return jsonResponse
              .map<LeaderBoardModel>((item) => LeaderBoardModel.fromJson(item))
              .toList();
        } else {
          print("Expected a list but got ${jsonResponse.runtimeType}");
          return null;
        }
      } else {
        print("Request failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
  }


  static Future<Map<String, dynamic>?> postAddLeads(
      String name,
      String num,
      String followup_date,
      String remarks,
      String lead_id,
      ) async {
    try {
      final Map<String, String> data = {
        "name": name,
        "number": num,
        "followup_date": followup_date,
        "remarks": remarks,
        "lead_stage_id": lead_id,
      };
       print("postAddLeads??${data}");
      final url = Uri.parse("${host}/api/add-lead");
      final headers = await getheader1();
      final response = await http.post(
        url,
        headers: headers,
        body: data,
      );

      if (response.body.isEmpty) {
        print("Empty response body.");
        return null;
      }

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print("postAddLeads successful: $jsonResponse");
        return jsonResponse;
      } else {
        print(
          "Request failed with status: ${response.statusCode}, body: $jsonResponse",
        );
        return jsonResponse;
      }
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
  }


  static Future<Map<String, dynamic>?> postAddFollowUp(
      String leadid,
      String name,
      String followup_date,
      String remarks,


      ) async {
    try {
      final Map<String, String> data = {
        "lead_id": leadid,
        "name": name,

        "followup_date": followup_date,
        "remarks": remarks,


      };
      print("postAddFollowUp??${data}");
      final url = Uri.parse("${host}/api/add-follow-up");
      final headers = await getheader1();
      final response = await http.post(
        url,
        headers: headers,
        body: data,
      );

      if (response.body.isEmpty) {
        print("Empty response body.");
        return null;
      }

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print("postAddFollowUp successful: $jsonResponse");
        return jsonResponse;
      } else {
        print(
          "Request failed with status: ${response.statusCode}, body: $jsonResponse",
        );
        return jsonResponse;
      }
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
  }


  static Future<ViewInfoModel?> getViewInfo(ID) async {
    try {
      final url = Uri.parse("${host}/api/view-info/$ID");
      final headers = await getheader1();
      final response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("getViewInfo response: ${response.body}");
        return ViewInfoModel.fromJson(jsonResponse);

      } else {
        print("Request failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
  }

  static Future<GetFollowUpModel?> getFollowup() async {
    try {
      final url = Uri.parse("${host}/api/follow_up_list");
      final headers = await getheader1();
      final response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("getFollowup response: ${response.body}");
        return GetFollowUpModel.fromJson(jsonResponse);
      } else {
        print("Request failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      // Log any errors
      print("Error occurred in getUserDetails: $e");
      return null;
    }
  }

}
