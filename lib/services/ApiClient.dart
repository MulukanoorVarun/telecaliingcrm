import 'dart:io';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../screens/SubscriptionExpiredScreen.dart';
import '../screens/TooManyRequestsScreen.dart';
import 'AuthService.dart';

import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ApiClient {
  static final logger = Logger();
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://api.telecallingcrm.com",
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {"Content-Type": "application/json"},
    ),
  );

  static void setupInterceptors(GlobalKey<NavigatorState> navigatorKey) {
    try {
      logger.d("[ApiClient] Setting up interceptors... NavigatorKey: $navigatorKey");
      logger.d("[ApiClient] Existing interceptors: ${_dio.interceptors.map((i) => i.runtimeType).toList()}");
      _dio.interceptors.clear();
      logger.d("[ApiClient] Cleared interceptors. Count: ${_dio.interceptors.length}");
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
              logger.d("[Interceptor] Set Authorization: ${options.headers['Authorization']}");
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
          logger.d("[Interceptor] Response from ${response.requestOptions.uri} - Status: ${response.statusCode}");
          _handleNavigation(response.statusCode, navigatorKey);
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          logger.e("[Interceptor] Error: ${e.message}");
          if (e.response != null) {
            logger.e("[Interceptor] Status: ${e.response?.statusCode}, Data: ${e.response?.data}");
            _handleNavigation(e.response?.statusCode, navigatorKey);
          }
          return handler.next(e); // No refresh logic yet
        },
      ));
      logger.d("[ApiClient] Interceptors added: ${_dio.interceptors.length}");
    } catch (e, stackTrace) {
      logger.e("[ApiClient] Error setting up interceptors: $e");
      logger.e("[ApiClient] Stack trace: $stackTrace");
    }
  }

  static Future<Response> post(String path, {dynamic data, Options? options}) async {
    logger.d("[API] POST $path");
    logger.d("[API] Interceptor count: ${_dio.interceptors.length}");
    try {
      return await _dio.post(path, data: data, options: options);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Response> get(String path, {Map<String, dynamic>? queryParameters, Options? options}) async {
    logger.d("[API] GET $path");
    logger.d("[API] Interceptor count: ${_dio.interceptors.length}");
    try {
      return await _dio.get(path, queryParameters: queryParameters, options: options);
    } catch (e) {
      return _handleError(e);
    }
  }

  static void _handleNavigation(int? statusCode, GlobalKey<NavigatorState> navigatorKey) {
    // Implement navigation logic as needed
  }

  static Future<Response> _handleError(dynamic e) async {
    logger.e("[API] Error: $e");
    return Future.error(e);
  }
}
