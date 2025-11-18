import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:http/http.dart' as http;
import 'package:the_dunes/core/network/api_constants.dart';
import 'package:the_dunes/core/network/api_exception.dart';
import 'package:the_dunes/core/network/api_response_handler.dart';

class ApiClientMethods {
  final String baseUrl;
  final Map<String, String> Function() getHeaders;

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
    final response = await http.get(uri, headers: getHeaders());
    return ApiResponseHandler.handleResponse(response);
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final normalizedEndpoint = endpoint.startsWith('/') 
        ? endpoint 
        : '/$endpoint';
    final uri = Uri.parse('$baseUrl$normalizedEndpoint');
    final headers = getHeaders();
    final bodyJson = jsonEncode(body);
    
    if (kDebugMode) {
      _logPostRequest(uri, normalizedEndpoint, headers, bodyJson);
    }
    
    try {
      final response = await http.post(uri, headers: headers, body: bodyJson);
      
      if (kDebugMode) {
        _logPostResponse(response);
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
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: getHeaders(),
      body: jsonEncode(body),
    );
    return ApiResponseHandler.handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: getHeaders(),
    );
    return ApiResponseHandler.handleResponse(response);
  }

  void _logPostRequest(Uri uri, String endpoint, Map<String, String> headers, String body) {
    print('[ApiClient] POST Request:');
    print('[ApiClient] Full URL: $uri');
    print('[ApiClient] Base URL: $baseUrl');
    print('[ApiClient] Endpoint: $endpoint');
    print('[ApiClient] Headers: $headers');
    print('[ApiClient] Body: $body');
    print('[ApiClient] Body Type: ${body.runtimeType}');
  }

  void _logPostResponse(http.Response response) {
    print('[ApiClient] Response Status: ${response.statusCode}');
    print('[ApiClient] Response Headers: ${response.headers}');
    print('[ApiClient] Response Body: ${response.body}');
  }
}

