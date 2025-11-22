import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_dunes/features/login/data/models/permissions_model.dart';

class TokenStorage {
  static const String _tokenKey = 'auth_token';
  static const String _languageKey = 'language';
  static const String _permissionsKey = 'user_permissions';
  static const String _userDataKey = 'user_data';

  static Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.setString(_tokenKey, token);
      if (success) {
        print('[TokenStorage] ✅ Token saved successfully');
        print('[TokenStorage]    Token length: ${token.length}');
        print('[TokenStorage]    Token preview: ${token.substring(0, token.length > 30 ? 30 : token.length)}...');
        
        // Verify token was saved
        final saved = await prefs.getString(_tokenKey);
        if (saved == token) {
          print('[TokenStorage] ✅ Token verification: SUCCESS');
        } else {
          print('[TokenStorage] ❌ Token verification: FAILED');
        }
      } else {
        print('[TokenStorage] ❌ Failed to save token!');
      }
    } catch (e) {
      print('[TokenStorage] ❌ Error saving token: $e');
      rethrow;
    }
  }

  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      if (token != null && token.isNotEmpty) {
        print('[TokenStorage] ✅ Token retrieved: ${token.length} chars');
      } else {
        print('[TokenStorage] ⚠️ No token found in storage');
      }
      return token;
    } catch (e) {
      print('[TokenStorage] ❌ Error getting token: $e');
      return null;
    }
  }

  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_permissionsKey);
    await prefs.remove(_userDataKey);
  }

  static Future<void> savePermissions(PermissionsModel permissions) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_permissionsKey, jsonEncode(permissions.toJson()));
  }

  static Future<PermissionsModel?> getPermissions() async {
    final prefs = await SharedPreferences.getInstance();
    final permissionsJson = prefs.getString(_permissionsKey);
    if (permissionsJson == null) return null;
    try {
      return PermissionsModel.fromJson(
        jsonDecode(permissionsJson) as Map<String, dynamic>,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, jsonEncode(userData));
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataJson = prefs.getString(_userDataKey);
    if (userDataJson == null) return null;
    try {
      return jsonDecode(userDataJson) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  static Future<void> saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language);
  }

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'en';
  }
}

