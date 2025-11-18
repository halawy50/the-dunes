import 'package:the_dunes/features/login/data/models/login_data.dart';

class LoginResponse {
  final bool success;
  final String message;
  final LoginData? data;
  final String? error;

  LoginResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? LoginData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      error: json['error'] as String?,
    );
  }
}

