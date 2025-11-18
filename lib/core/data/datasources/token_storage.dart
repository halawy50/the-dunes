import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_dunes/features/login/data/models/permissions_model.dart';

class TokenStorage {
  static const String _tokenKey = 'auth_token';
  static const String _languageKey = 'language';
  static const String _permissionsKey = 'user_permissions';
  static const String _userDataKey = 'user_data';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
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

