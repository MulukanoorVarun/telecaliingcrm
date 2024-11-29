import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:telecaliingcrm/model/DashBoardModel.dart';
import 'package:telecaliingcrm/model/UserDetailsModel.dart';
import 'package:telecaliingcrm/services/otherservices.dart';
import '../model/RegisterModel.dart';


class Userapi {
  static String host = "https://api.telecallingcrm.com";

  static Future<Map<String, dynamic>?> PostSignIn(String email, String pwd) async {
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
        print("Request failed with status: ${response.statusCode}, body: $jsonResponse");
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


  static Future<UserDetailsModel?> DahsBoardApi() async {
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






}
