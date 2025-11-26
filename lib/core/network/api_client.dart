import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:the_dunes/core/data/datasources/token_storage.dart';
import 'package:the_dunes/core/network/api_constants.dart';
import 'package:the_dunes/core/network/api_client_methods.dart';

class ApiClient {
  final String baseUrl;
  String? _token;
  String _language = 'en';
  late final ApiClientMethods _methods;

  ApiClient({String? baseUrl}) 
      : baseUrl = baseUrl ?? ApiConstants.baseUrl {
    _methods = ApiClientMethods(
      baseUrl: this.baseUrl,
      getHeaders: _getHeaders,
    );
  }

  void setToken(String? token) {
    _token = token;
    if (kDebugMode) {
      if (token != null && token.isNotEmpty) {
        print('[ApiClient] 🔄 Token updated in ApiClient cache');
        print('[ApiClient]    Token length: ${token.length}');
        print('[ApiClient]    Token preview: ${token.substring(0, token.length > 30 ? 30 : token.length)}...');
      } else {
        print('[ApiClient] ⚠️ Token cleared from ApiClient cache');
      }
    }
  }

  void setLanguage(String language) {
    _language = language;
  }

  Future<Map<String, String>> _getHeaders() async {
    final headers = <String, String>{
      ApiConstants.contentTypeHeader: 
          '${ApiConstants.applicationJson}; charset=utf-8',
      ApiConstants.acceptLanguageHeader: _language,
      'Accept': ApiConstants.applicationJson,
    };

    // CRITICAL: Always get token from storage to ensure it's up-to-date
    // Then check cache as fallback
    String? token = await TokenStorage.getToken();
    
    if (token == null || token.isEmpty) {
      // Fallback to cache if storage is empty
      token = _token;
      if (kDebugMode) {
        print('[ApiClient] ⚠️ Token from storage is NULL, using cache');
      }
    } else {
      // Update cache with latest token from storage
      _token = token;
      if (kDebugMode) {
        print('[ApiClient] ✅ Token retrieved from TokenStorage');
      }
    }
    
    if (token != null && token.isNotEmpty) {
      // Remove "Bearer " prefix if token already contains it
      String cleanToken = token.trim();
      if (cleanToken.startsWith('Bearer ')) {
        cleanToken = cleanToken.substring(7).trim();
      }
      
      // Header Format:
      // Key: Authorization
      // Value: Bearer {accessToken}
      final authValue = '${ApiConstants.bearerPrefix} $cleanToken';
      headers[ApiConstants.authorizationHeader] = authValue;
      
      if (kDebugMode) {
        print('[ApiClient] ✅✅✅ Authorization Header Added ✅✅✅');
        print('[ApiClient]    Key: ${ApiConstants.authorizationHeader}');
        print('[ApiClient]    Value: Bearer ${cleanToken.substring(0, cleanToken.length > 20 ? 20 : cleanToken.length)}...');
        print('[ApiClient]    Full Value: $authValue');
        print('[ApiClient]    Token length: ${cleanToken.length}');
      }
    } else {
      if (kDebugMode) {
        print('[ApiClient] ❌❌❌ CRITICAL ERROR: NO TOKEN AVAILABLE! ❌❌❌');
        print('[ApiClient] This request will FAIL with 401 Unauthorized!');
        print('[ApiClient] Token from cache: ${_token != null ? "EXISTS (${_token!.length} chars)" : "NULL"}');
        final storageToken = await TokenStorage.getToken();
        print('[ApiClient] Token from storage: ${storageToken != null ? "EXISTS (${storageToken.length} chars)" : "NULL"}');
      }
    }

    return headers;
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    return _methods.get(endpoint, queryParams: queryParams);
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    return _methods.post(endpoint, body);
  }

  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? queryParams,
  }) async {
    return _methods.put(endpoint, body, queryParams: queryParams);
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    return _methods.delete(endpoint);
  }
}

