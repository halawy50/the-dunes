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
  }

  void setLanguage(String language) {
    _language = language;
  }

  Map<String, String> _getHeaders() {
    final headers = <String, String>{
      ApiConstants.contentTypeHeader: 
          '${ApiConstants.applicationJson}; charset=utf-8',
      ApiConstants.acceptLanguageHeader: _language,
      'Accept': ApiConstants.applicationJson,
    };

    if (_token != null) {
      headers[ApiConstants.authorizationHeader] =
          '${ApiConstants.bearerPrefix} $_token';
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
    Map<String, dynamic> body,
  ) async {
    return _methods.put(endpoint, body);
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    return _methods.delete(endpoint);
  }
}

