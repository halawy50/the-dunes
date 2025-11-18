import 'package:the_dunes/features/login/domain/entities/user_entity.dart';
import 'package:the_dunes/features/login/data/models/employee_data.dart';

class UserModel extends UserEntity {
  final String? image;

  const UserModel({
    required super.id,
    required super.email,
    super.name,
    this.image,
  });

  factory UserModel.fromEmployeeData(EmployeeData employeeData) {
    return UserModel(
      id: employeeData.id.toString(),
      email: employeeData.email,
      name: employeeData.name,
      image: employeeData.image,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'image': image,
    };
  }
}
