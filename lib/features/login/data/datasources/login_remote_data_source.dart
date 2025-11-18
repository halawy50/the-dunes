import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:the_dunes/core/network/api_client.dart';
import 'package:the_dunes/core/network/api_constants.dart';
import 'package:the_dunes/features/login/data/models/login_request.dart';
import 'package:the_dunes/features/login/data/models/login_response.dart';

abstract class LoginRemoteDataSource {
  Future<LoginResponse> login(String email, String password);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final ApiClient apiClient;

  LoginRemoteDataSourceImpl(this.apiClient);

  @override
  Future<LoginResponse> login(String email, String password) async {
    final request = LoginRequest(email: email, password: password);
    final requestBody = request.toJson();
    
    if (kDebugMode) {
      print('[LoginRemoteDataSource] Request body: $requestBody');
      print('[LoginRemoteDataSource] Endpoint: ${ApiConstants.loginEndpoint}');
    }
    
    final response = await apiClient.post(
      ApiConstants.loginEndpoint,
      requestBody,
    );
    
    if (kDebugMode) {
      print('[LoginRemoteDataSource] Response: $response');
    }
    
    return LoginResponse.fromJson(response);
  }
}

