import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:telecaliingcrm/model/CallHistoryModel.dart';
import 'package:telecaliingcrm/model/DashBoardModel.dart';
import 'package:telecaliingcrm/model/LeadsModel.dart';
import 'package:telecaliingcrm/model/LeadeBoardModel.dart';
import 'package:telecaliingcrm/model/UserDetailsModel.dart';
import 'package:telecaliingcrm/screens/SubscriptionExpiredScreen.dart';
import 'package:telecaliingcrm/screens/TooManyRequestsScreen.dart';
import 'package:telecaliingcrm/services/otherservices.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:telecaliingcrm/utils/constants.dart';
import '../model/RegisterModel.dart';
import '../model/ViewInfoModel.dart';
import '../model/GetFollowUpModel.dart';
import '../utils/preferences.dart';

class Userapi {
  static String host = "https://api.telecallingcrm.com";

  static Future<Map<String, dynamic>?> PostSignIn(
      String email, String pwd, BuildContext context) async {
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
      } else if (response.statusCode == 403) {
        {
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return SubscriptionExpiredScreen();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
          ));
        }
      } else {
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

  static Future<DashBoardModel?> DahsBoardApi(BuildContext context) async {
    if (await checkHeaderValidity()) {
      try {
        final url = Uri.parse("${host}/api/dashboard");
        final headers = await getheader1();
        final response = await http.post(
          url,
          headers: headers,
        );
        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          print("DahsBoardApi response: ${response.body}");
          return DashBoardModel.fromJson(jsonResponse);
        } else if (response.statusCode == 429) {

            Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return TooManyRequestsScreen();
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(position: offsetAnimation, child: child);
              },
            ));}
        else if (response.statusCode == 403) {

            Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return SubscriptionExpiredScreen();
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(position: offsetAnimation, child: child);
              },
            ));

        }else {
          // Handle non-200 responses (e.g., 401, 404, etc.)
          print("DahsBoardApi response: ${response.body}");
          print("Request failed with status: ${response.statusCode}");
          return null;
        }
      } catch (e) {
        // Catch and log any errors
        print("Error occurred: $e");
        return null;
      }
    } else {
      // Catch and log any errors
      print("returned");
      return null;
    }
  }

  static Future<UserDetailsModel?> getUserDetails(BuildContext context) async {
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
      }else if (response.statusCode == 403) {

        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return SubscriptionExpiredScreen();
          },
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        ));

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
      String id, String call_status, String call_duration, BuildContext context) async {
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
      if (response.statusCode == 200) {
        try {
          final jsonResponse = jsonDecode(response.body);
          print("Request successful: $jsonResponse");
          return jsonResponse;
        } catch (e) {
          print(
              "Error: Failed to decode response body. Response: ${response.body}");
          return null;
        }
      }else if (response.statusCode == 403) {

        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return SubscriptionExpiredScreen();
          },
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        ));

      } else {
        print(
            "Request failed with status: ${response.statusCode}, body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
  }

  static Future<LeadsModel?> getLeads(type, page,BuildContext context) async {
    try {
      final url = Uri.parse(
          "${host}/api/get_lead_calls?stagename=${type}&page=${page}");
      final headers = await getheader1();
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("getLeads response: ${response.body}");
        return LeadsModel.fromJson(jsonResponse);
      }else if (response.statusCode == 403) {

        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return SubscriptionExpiredScreen();
          },
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        ));

      } else {
        print("Request failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error occurred in getLeads: $e");
      return null;
    }
  }

  static Future<LeaderBoardModel?> getLeaderboard(_currentPage,BuildContext context) async {
    try {
      final url =
          Uri.parse("${host}/api/get_leader_board?page=${_currentPage}");
      final headers = await getheader1();
      final response = await http.post(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("getLeaderboard response: ${response.body}");
        return LeaderBoardModel.fromJson(jsonResponse);
      }else if (response.statusCode == 429) {

          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return TooManyRequestsScreen();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
          ));

      } else if (response.statusCode == 403) {

          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return SubscriptionExpiredScreen();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
          ));

      } else {
        print("Request failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
    return null;
  }

  static Future<Map<String, dynamic>?> postAddLeads(
    String name,
    String num,
    String followup_date,
    String remarks,
    String lead_id,BuildContext context
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
      }else if (response.statusCode == 403) {

        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return SubscriptionExpiredScreen();
          },
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        ));

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
    String remarks,BuildContext context
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
      }else if (response.statusCode == 403) {

        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return SubscriptionExpiredScreen();
          },
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        ));

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

  static Future<Map<String, dynamic>?> postUpdateLeads(
    String name,
    String lead_id,
    String remarks,
    String lead_stage_id,
    String deal_stage,BuildContext context
  ) async {
    try {
      final Map<String, String> data = {
        "name": name,
        "lead_id": lead_id,
        "remarks": remarks,
        "lead_stage_id": lead_stage_id,
        "deal_stage": deal_stage,
      };
      print("postUpdateLeads??${data}");
      final url = Uri.parse("${host}/api/update-info");
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
        print("postUpdateLeads successful: $jsonResponse");
        return jsonResponse;
      }else if (response.statusCode == 403) {

        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return SubscriptionExpiredScreen();
          },
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        ));

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
      print(url);
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

  static Future<GetFollowUpModel?> getFollowup(page, BuildContext context) async {
    try {
      final url = Uri.parse("${host}/api/follow_up_list?page=$page");
      final headers = await getheader1();
      final response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("getFollowup response: ${response.body}");
        return GetFollowUpModel.fromJson(jsonResponse);
      }else if (response.statusCode == 403) {

        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return SubscriptionExpiredScreen();
          },
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        ));

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

  static Future<String?> updateProfile(
      UserID, String fullname, String email, File? image,BuildContext context) async {
    try {
      final url = Uri.parse(
          'https://api.telecallingcrm.com/api/update-profile/${UserID}');

      // Create a MultipartRequest for a multipart form upload
      final request = http.MultipartRequest('POST', url);
      final sessionid = await PreferenceService().getString("token");
      request.headers['Authorization'] = 'Bearer $sessionid';

      request.fields['username'] = fullname;
      request.fields['email'] = email;

      if (image != null) {
        final mimeType = lookupMimeType(image.path);
        print("Image MIME type: $mimeType");
        if (mimeType != null && mimeType.startsWith('image/')) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'photo', // The name of the file field in your API
              image.path,
              contentType: MediaType.parse(mimeType),
            ),
          );
        } else {
          print('Invalid image file');
          return null;
        }
      }
      print("Requested fields: ${request.fields}");
      // Send the request and capture the response
      final response = await request.send();
      // Read the response body
      final responseData = await response.stream.bytesToString();
      print("Response Body: $responseData");
      // Handle successful response
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseData);
        if (jsonResponse['message'] == 'User updated successfully') {
          return 'Profile updated successfully.';
        } else {
          return 'Profile update failed: ${jsonResponse['message']}';
        }
      }else if (response.statusCode == 403) {

        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return SubscriptionExpiredScreen();
          },
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        ));

      } else {
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> UpdateRefreshToken() async {
    try {
      final url = Uri.parse("${host}/api/refresh-token");
      final headers = await getheader1();
      final response = await http.post(
        url,
        headers: headers,
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
      debugPrint('hello bev=bug $e ');
      return null;
    }
  }

  static Future<CallHistoryModel?> getCallHistory(date, page,BuildContext context) async {
    try {
      final url = Uri.parse(
          "${host}/api/today-called-history?latest_update=${date}&page=${page}");
      final header = await getheader1();
      final response = await http.get(url, headers: header);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print("getCallHistory response:${jsonResponse}");
        return CallHistoryModel.fromJson(jsonResponse);
      } else if (response.statusCode == 429) {

          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return TooManyRequestsScreen();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
          ));
        }
        else if (response.statusCode == 403) {

          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return SubscriptionExpiredScreen();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
          ));

      }else {
        return null;
      }
    } catch (e) {
      debugPrint('Error occurred: $e');
      return null;
    }
  }

  static Future<bool?> updatePassword(
      String email, String password, BuildContext context) async {
    try {
      final Uri url = Uri.parse('${host}/api/update_password');
      final response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status']) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          CustomSnackBar.show(context, responseData['message']);
          return true;
        } else {
          final Map<String, dynamic> responseData = json.decode(response.body);
          CustomSnackBar.show(context, responseData['message']);
          return false;
        }
      }else if (response.statusCode == 403) {

        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return SubscriptionExpiredScreen();
          },
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        ));

      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Error occurred: $e');
      return null;
    }
  }

  static Future<bool?> forgetPassword(
      String email, BuildContext context) async {
    try {
      final Uri url = Uri.parse('${host}/api/forget-password');
      final response = await http.post(
        url,
        body: {
          'email': email,
        },
      );

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // Handle successful response
        CustomSnackBar.show(context, responseData['message']);
        return true;
      }else if (response.statusCode == 403) {

        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return SubscriptionExpiredScreen();
          },
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        ));

      } else if (response.statusCode == 400) {
        // Handle invalid email scenario
        if (responseData.containsKey('email')) {
          // Email is not registered
          CustomSnackBar.show(context, responseData['email'][0]);
        } else {
          // Other error messages
          CustomSnackBar.show(context, "An error occurred.");
        }
        return false;
      } else {
        // Handle any other unsuccessful response
        CustomSnackBar.show(
            context, "Unexpected error: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint('Error occurred: $e');
      CustomSnackBar.show(context, "An error occurred. Please try again.");
      return null; // In case of error (e.g., no network)
    }
  }

  static Future<bool?> forgetPasswordOtpVerify(
      String email, String otp, BuildContext context) async {
    try {
      final Uri url = Uri.parse('${host}/api/verify-otp');
      final response = await http.post(
        url,
        body: {
          'email': email,
          'otp': otp,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        CustomSnackBar.show(context, responseData['message']);
        return true;
      }else if (response.statusCode == 403) {

        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return SubscriptionExpiredScreen();
          },
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        ));

      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        CustomSnackBar.show(context, responseData['message']);
        return false;
      }
    } catch (e) {
      debugPrint('Error occurred: $e');
      return null;
    }
  }
}
