import 'package:the_dunes/features/login/data/models/employee_data.dart';

class LoginData {
  final String token;
  final EmployeeData employee;

  LoginData({
    required this.token,
    required this.employee,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      token: json['accessToken'] as String? ?? json['token'] as String? ?? '',
      employee: EmployeeData.fromJson(
        json['employee'] as Map<String, dynamic>,
      ),
    );
  }
}

