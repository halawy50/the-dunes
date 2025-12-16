import 'dart:convert';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:http/http.dart' as http;
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
      print('[ApiClient] GET Request: $uri');
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
      
      if (kDebugMode && response.statusCode == 401) {
        print('[ApiClient] ⚠️ 401 UNAUTHORIZED');
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
    // Only encode body if it's not empty, otherwise send empty string
    final bodyJson = body.isEmpty ? '' : jsonEncode(body);
    
    if (kDebugMode) {
      _logPostRequest(uri, normalizedEndpoint, headers, bodyJson);
    }
    
    try {
      final response = await http.post(
        uri, 
        headers: headers, 
        body: bodyJson.isEmpty ? null : bodyJson,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw ApiException(
            message: 'errors.connection_timeout'.tr(),
            error: 'Request timeout',
            statusCode: 0,
          );
        },
      );
      
      if (kDebugMode && response.statusCode == 401) {
        print('[ApiClient] ⚠️ 401 UNAUTHORIZED');
      }
      
      return ApiResponseHandler.handleResponse(response);
    } on http.ClientException catch (e) {
      if (kDebugMode) {
        print('[ApiClient] ClientException: $e');
        print('[ApiClient] URI: $uri');
        print('[ApiClient] This is likely a CORS issue in Flutter Web.');
        print('[ApiClient] The server may have processed the request successfully,');
        print('[ApiClient] but the browser blocked the response due to CORS policy.');
        print('[ApiClient] Check server CORS configuration to allow:');
        print('[ApiClient] - Origin: ${Uri.base.origin}');
        print('[ApiClient] - Headers: Content-Type, Authorization, Accept-Language');
        print('[ApiClient] - Methods: POST, GET, PUT, DELETE, OPTIONS');
      }
      throw ApiException(
        message: 'errors.cors_error'.tr(),
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

  Future<Map<String, dynamic>> postMultipart(
    String endpoint,
    Map<String, dynamic> fields,
    Map<String, Uint8List>? files,
  ) async {
    final normalizedEndpoint = endpoint.startsWith('/') 
        ? endpoint 
        : '/$endpoint';
    final uri = Uri.parse('$baseUrl$normalizedEndpoint');
    final headers = await getHeaders();
    
    // Remove Content-Type header for multipart (it will be set automatically)
    final multipartHeaders = Map<String, String>.from(headers);
    multipartHeaders.remove('Content-Type');
    
    if (kDebugMode) {
      print('[ApiClient] ========================================');
      print('[ApiClient] POST Multipart Request:');
      print('[ApiClient] Full URL: $uri');
      print('[ApiClient] Method: POST (multipart/form-data)');
      print('[ApiClient] Fields: $fields');
      print('[ApiClient] Files: ${files?.keys.toList()}');
      print('[ApiClient] ========================================');
    }
    
    try {
      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll(multipartHeaders);
      
      // Add fields
      fields.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });
      
      // Add files
      if (files != null) {
        files.forEach((key, bytes) {
          if (bytes.isNotEmpty) {
            request.files.add(
              http.MultipartFile.fromBytes(
                key,
                bytes,
                filename: key == 'image' ? 'image.jpg' : 'file',
              ),
            );
          }
        });
      }
      
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw ApiException(
            message: 'errors.connection_timeout'.tr(),
            error: 'Request timeout',
            statusCode: 0,
          );
        },
      );
      
      final response = await http.Response.fromStream(streamedResponse);
      
      if (kDebugMode) {
        print('[ApiClient] POST Multipart Response Status: ${response.statusCode}');
        print('[ApiClient] Response Body: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}');
      }
      
      return ApiResponseHandler.handleResponse(response);
    } on http.ClientException catch (e) {
      if (kDebugMode) {
        print('[ApiClient] POST Multipart ClientException: $e');
      }
      throw ApiException(
        message: 'errors.connection_error'.tr(),
        error: e.toString(),
        statusCode: 0,
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('[ApiClient] POST Multipart Exception: $e');
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
    Map<String, dynamic> body, {
    Map<String, String>? queryParams,
  }) async {
    final baseUri = Uri.parse('$baseUrl$endpoint');
    final uri = queryParams != null && queryParams.isNotEmpty
        ? baseUri.replace(queryParameters: queryParams)
        : baseUri;
    final headers = await getHeaders();
    
    // Only encode body if it's not empty, otherwise send null
    final bodyJson = body.isEmpty ? null : jsonEncode(body);
    
    if (kDebugMode) {
      print('[ApiClient] PUT Request: $uri');
    }
    
    final response = await http.put(
      uri,
      headers: headers,
      body: bodyJson,
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
      print('[ApiClient] DELETE Request: $uri');
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
    if (kDebugMode) {
      print('[ApiClient] POST Request: $uri');
    }
  }

  void _logPostResponse(http.Response response) {
    if (kDebugMode && response.statusCode == 401) {
      print('[ApiClient] ⚠️ 401 UNAUTHORIZED');
    }
  }
}

