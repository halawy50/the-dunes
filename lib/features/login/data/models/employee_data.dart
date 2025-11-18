import 'package:the_dunes/features/login/data/models/permissions_model.dart';

class EmployeeData {
  final int id;
  final String name;
  final String email;
  final String? image;
  final PermissionsModel? permissions;

  EmployeeData({
    required this.id,
    required this.name,
    required this.email,
    this.image,
    this.permissions,
  });

  factory EmployeeData.fromJson(Map<String, dynamic> json) {
    return EmployeeData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] as String?,
      permissions: json['permissions'] != null
          ? PermissionsModel.fromJson(
              json['permissions'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

