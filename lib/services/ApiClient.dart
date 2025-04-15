import 'dart:io';
import 'package:dio/dio.dart';
import '../screens/SubscriptionExpiredScreen.dart';
import '../screens/TooManyRequestsScreen.dart';
import 'AuthService.dart';

import 'package:flutter/material.dart';


class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://api.telecallingcrm.com",
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  static void setupInterceptors(GlobalKey<NavigatorState> navigatorKey) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final accessToken = await AuthService.getAccessToken();
        print("Access token:${accessToken}");
        if (accessToken != null) {
          options.headers["Authorization"] = "Bearer $accessToken";
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Handle successful responses or specific status codes
        _handleNavigation(response.statusCode,navigatorKey);
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        if (e.response != null) {
          final statusCode = e.response?.statusCode;
          _handleNavigation(statusCode,navigatorKey);

          switch (statusCode) {
            case 400:
              print("Bad Request: ${e.response?.data}");
              break;
            case 401:
              print("Unauthorized: Attempting token refresh...");
              bool refreshed = await _refreshToken();
              if (refreshed) {
                final newAccessToken = await AuthService.getAccessToken();
                e.requestOptions.headers["Authorization"] =
                "Bearer $newAccessToken";
                try {
                  final retryResponse = await _dio.fetch(e.requestOptions);
                  return handler.resolve(retryResponse);
                } catch (retryError) {
                  return handler.reject(DioException(
                    requestOptions: e.requestOptions,
                    error: retryError,
                    message: "Error retrying request",
                  ));
                }
              }
              break;
            case 403:
              print("Forbidden: ${e.response?.data}");
              break;
            case 404:
              print("Not Found: ${e.response?.data}");
              break;
            case 429:
              print("Too Many Requests: ${e.response?.data}");
              break;
            case 500:
              print("Server Error: ${e.response?.data}");
              break;
          }
        } else {
          if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.sendTimeout ||
              e.type == DioExceptionType.receiveTimeout) {
            print("Timeout Error: ${e.message}");
          } else if (e.error is SocketException) {
            print("No Internet Connection: ${e.error}");
          } else {
            print("Unexpected Error: ${e.message}");
          }
        }
        return handler.next(e);
      },
    ));
  }

  static void _handleNavigation(int? statusCode,GlobalKey<NavigatorState> navigatorKey) {
    if (navigatorKey.currentState == null) {
      print("Navigator key not initialized");
      return;
    }

    switch (statusCode) {
      case 403:
        navigatorKey.currentState!.push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              SubscriptionExpiredScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        ));
        break;
      case 429:
        navigatorKey!.currentState!.push(
            PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              TooManyRequestsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        ));
        break;
    }
  }

  static Future<bool> _refreshToken() async {
    try {
      final newToken = await AuthService.refreshToken();
      if (newToken != null) {
        print("Token refreshed successfully");
        return true;
      }
    } catch (e) {
      print("Token refresh failed: $e");
    }
    return false;
  }

  static Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Response _handleError(dynamic error) {
    if (error is DioException) {
      print("DioException occurred: ${error.message}");
      throw error;
    } else {
      print("Unexpected error: $error");
      throw Exception("Unexpected error occurred");
    }
  }
}
