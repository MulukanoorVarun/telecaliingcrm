import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import '../model/RegisterModel.dart';


class Userapi {
  static String host = "https://api.telecallingcrm.com";

  // static Future<RegisterModel?> PostRegister(String fullname, String mail,
  //     String phone, String password, String gender) async {
  //   try {
  //     Map<String, String> data = {
  //       "full_name": fullname,
  //       "email": mail,
  //       "mobile": phone,
  //       "password": password,
  //       "gender": gender
  //     };
  //     final url = Uri.parse("${host}/auth/register");
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         HttpHeaders.contentTypeHeader: "application/json",
  //       },
  //       body: jsonEncode(data),
  //     );
  //     if (response != null) {
  //       final jsonResponse = jsonDecode(response.body);
  //       print("PostRegister Status:${response.body}");
  //       return RegisterModel.fromJson(jsonResponse);
  //     } else {
  //       print("Request failed with status: ${response.statusCode}");
  //       return null;
  //     }
  //   } catch (e) {
  //     print("Error occurred: $e");
  //     return null;
  //   }
  // }
  //
  static Future<RegisterModel?> PostSignIn(String email,String pwd) async {
    try { 
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
      if (response != null) {
        final jsonResponse = jsonDecode(response.body);
        print("PostSignIn Status:${response.body}");
        return RegisterModel.fromJson(jsonResponse);
      } else {
        print("Request failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
  }







}
