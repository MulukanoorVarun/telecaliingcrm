import 'package:shared_preferences/shared_preferences.dart';

import 'ApiClient.dart';

class AuthService {
  static const String _accessTokenKey = "access_token";

  static Future<String?> getAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_accessTokenKey);
      ApiClient.logger.d("[AuthService] Retrieved token: $token");
      return token;
    } catch (e) {
      ApiClient.logger.e("[AuthService] Error getting token: $e");
      return null;
    }
  }

  static Future<void> saveAccessToken(String accessToken) async {
    try {
      ApiClient.logger.d("[AuthService] Saving token: $accessToken");
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_accessTokenKey, accessToken);
    } catch (e) {
      ApiClient.logger.e("[AuthService] Error saving token: $e");
    }
  }
}
