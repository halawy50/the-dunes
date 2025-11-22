import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:http/http.dart' as http;
import 'package:the_dunes/core/network/api_constants.dart';
import 'package:the_dunes/core/network/api_exception.dart';
import 'package:the_dunes/core/network/api_response_handler.dart';

class ApiClientMethods {
  final String baseUrl;
  final Future<Map<String, String>> Function() getHeaders;

  ApiClientMethods({
    required this.baseUrl,
    required this.getHeaders,
  });

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint')
        .replace(queryParameters: queryParams);
    
    final headers = await getHeaders();
    
    if (kDebugMode) {
      print('[ApiClient] ========================================');
      print('[ApiClient] GET Request:');
      print('[ApiClient] Full URL: $uri');
      print('[ApiClient] Method: GET');
      print('[ApiClient] Headers Count: ${headers.length}');
      print('[ApiClient] Headers: $headers');
      
      if (headers.containsKey('Authorization')) {
        final authHeader = headers['Authorization']!;
        final tokenPreview = authHeader.length > 50 
            ? '${authHeader.substring(0, 50)}...' 
            : authHeader;
        print('[ApiClient] ✅ Authorization header EXISTS');
        print('[ApiClient] ✅ Authorization value: $tokenPreview');
        // Verify format: should be "Bearer {token}"
        if (authHeader.startsWith('Bearer ')) {
          final token = authHeader.substring(7);
          print('[ApiClient] ✅ Authorization format is CORRECT: Bearer {token}');
          print('[ApiClient] ✅ Token length: ${token.length}');
          print('[ApiClient] ✅ Token preview: ${token.length > 20 ? token.substring(0, 20) : token}...');
        } else {
          print('[ApiClient] ⚠️ Authorization format INCORRECT. Expected: "Bearer {token}"');
          print('[ApiClient] ⚠️ Actual format: ${authHeader.substring(0, authHeader.length > 30 ? 30 : authHeader.length)}');
        }
      } else {
        print('[ApiClient] ❌❌❌ Authorization header MISSING! ❌❌❌');
        print('[ApiClient] Available headers: ${headers.keys.toList()}');
      }
      print('[ApiClient] ========================================');
    }
    
    try {
      final response = await http.get(uri, headers: headers).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw ApiException(
            message: 'errors.connection_timeout'.tr(),
            error: 'Request timeout',
            statusCode: 0,
          );
        },
      );
      
      if (kDebugMode) {
        print('[ApiClient] GET Response Status: ${response.statusCode}');
        if (response.statusCode == 401) {
          print('[ApiClient] ⚠️⚠️⚠️ 401 UNAUTHORIZED ⚠️⚠️⚠️');
          print('[ApiClient] Full Response Body: ${response.body}');
          print('[ApiClient] Response Headers: ${response.headers}');
        } else {
          print('[ApiClient] GET Response Body: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}');
        }
      }
      
      return ApiResponseHandler.handleResponse(response);
    } on http.ClientException catch (e) {
      if (kDebugMode) {
        print('[ApiClient] GET ClientException: $e');
        print('[ApiClient] This is likely a CORS issue in Flutter Web.');
        print('[ApiClient] Make sure your server allows CORS requests with Authorization header.');
      }
      throw ApiException(
        message: 'errors.connection_error'.tr(),
        error: e.toString(),
        statusCode: 0,
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('[ApiClient] GET Exception occurred: $e');
        print('[ApiClient] Stack trace: $stackTrace');
      }
      if (e is ApiException) rethrow;
      throw ApiException(
        message: e.toString(),
        error: e.toString(),
        statusCode: 0,
      );
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final normalizedEndpoint = endpoint.startsWith('/') 
        ? endpoint 
        : '/$endpoint';
    final uri = Uri.parse('$baseUrl$normalizedEndpoint');
    final headers = await getHeaders();
    final bodyJson = jsonEncode(body);
    
    if (kDebugMode) {
      _logPostRequest(uri, normalizedEndpoint, headers, bodyJson);
    }
    
    try {
      final response = await http.post(uri, headers: headers, body: bodyJson);
      
      if (kDebugMode) {
        _logPostResponse(response);
        if (response.statusCode == 401) {
          print('[ApiClient] ⚠️⚠️⚠️ 401 UNAUTHORIZED ⚠️⚠️⚠️');
          print('[ApiClient] Full Response Body: ${response.body}');
        }
      }
      
      return ApiResponseHandler.handleResponse(response);
    } on http.ClientException catch (e) {
      if (kDebugMode) {
        print('[ApiClient] ClientException: $e');
        print('[ApiClient] This is likely a CORS issue in Flutter Web.');
      }
      throw ApiException(
        message: 'errors.server_error'.tr(),
        error: e.toString(),
        statusCode: 0,
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('[ApiClient] Exception occurred: $e');
        print('[ApiClient] Stack trace: $stackTrace');
      }
      if (e is ApiException) rethrow;
      throw ApiException(
        message: e.toString(),
        error: e.toString(),
        statusCode: 0,
      );
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final headers = await getHeaders();
    
    if (kDebugMode) {
      print('[ApiClient] ========================================');
      print('[ApiClient] PUT Request:');
      print('[ApiClient] Full URL: $uri');
      print('[ApiClient] Method: PUT');
      print('[ApiClient] Headers Count: ${headers.length}');
      
      if (headers.containsKey('Authorization')) {
        final authHeader = headers['Authorization']!;
        print('[ApiClient] ✅ Authorization header EXISTS');
        print('[ApiClient] ✅ Authorization value: ${authHeader.substring(0, authHeader.length > 50 ? 50 : authHeader.length)}...');
        if (authHeader.startsWith('Bearer ')) {
          print('[ApiClient] ✅ Authorization format is CORRECT: Bearer {token}');
        }
      } else {
        print('[ApiClient] ❌❌❌ Authorization header MISSING! ❌❌❌');
      }
      print('[ApiClient] ========================================');
    }
    
    final response = await http.put(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );
    
    if (kDebugMode && response.statusCode == 401) {
      print('[ApiClient] ⚠️⚠️⚠️ 401 UNAUTHORIZED ⚠️⚠️⚠️');
      print('[ApiClient] Full Response Body: ${response.body}');
    }
    
    return ApiResponseHandler.handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final headers = await getHeaders();
    
    if (kDebugMode) {
      print('[ApiClient] ========================================');
      print('[ApiClient] DELETE Request:');
      print('[ApiClient] Full URL: $uri');
      print('[ApiClient] Method: DELETE');
      print('[ApiClient] Headers Count: ${headers.length}');
      
      if (headers.containsKey('Authorization')) {
        final authHeader = headers['Authorization']!;
        print('[ApiClient] ✅ Authorization header EXISTS');
        print('[ApiClient] ✅ Authorization value: ${authHeader.substring(0, authHeader.length > 50 ? 50 : authHeader.length)}...');
        if (authHeader.startsWith('Bearer ')) {
          print('[ApiClient] ✅ Authorization format is CORRECT: Bearer {token}');
        }
      } else {
        print('[ApiClient] ❌❌❌ Authorization header MISSING! ❌❌❌');
      }
      print('[ApiClient] ========================================');
    }
    
    final response = await http.delete(
      uri,
      headers: headers,
    );
    
    if (kDebugMode && response.statusCode == 401) {
      print('[ApiClient] ⚠️⚠️⚠️ 401 UNAUTHORIZED ⚠️⚠️⚠️');
      print('[ApiClient] Full Response Body: ${response.body}');
    }
    
    return ApiResponseHandler.handleResponse(response);
  }

  void _logPostRequest(Uri uri, String endpoint, Map<String, String> headers, String body) {
    print('[ApiClient] ========================================');
    print('[ApiClient] POST Request:');
    print('[ApiClient] Full URL: $uri');
    print('[ApiClient] Method: POST');
    print('[ApiClient] Headers Count: ${headers.length}');
    print('[ApiClient] Headers: $headers');
    
    if (headers.containsKey('Authorization')) {
      final authHeader = headers['Authorization']!;
      final tokenPreview = authHeader.length > 50 
          ? '${authHeader.substring(0, 50)}...' 
          : authHeader;
      print('[ApiClient] ✅ Authorization header EXISTS');
      print('[ApiClient] ✅ Authorization value: $tokenPreview');
      if (authHeader.startsWith('Bearer ')) {
        print('[ApiClient] ✅ Authorization format is CORRECT: Bearer {token}');
      } else {
        print('[ApiClient] ⚠️ Authorization format INCORRECT. Expected: "Bearer {token}"');
      }
    } else {
      print('[ApiClient] ❌❌❌ Authorization header MISSING! ❌❌❌');
    }
    
    print('[ApiClient] Body: $body');
    print('[ApiClient] ========================================');
  }

  void _logPostResponse(http.Response response) {
    print('[ApiClient] Response Status: ${response.statusCode}');
    print('[ApiClient] Response Headers: ${response.headers}');
    print('[ApiClient] Response Body: ${response.body}');
  }
}

