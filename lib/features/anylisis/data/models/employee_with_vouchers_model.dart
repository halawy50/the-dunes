import 'package:the_dunes/features/anylisis/domain/entities/employee_with_vouchers_entity.dart';

class EmployeeWithVouchersModel extends EmployeeWithVouchersEntity {
  const EmployeeWithVouchersModel({
    required super.employeeId,
    required super.employeeName,
    required super.areaOfLocation,
    super.hotel,
    required super.voucherCount,
  });

  factory EmployeeWithVouchersModel.fromJson(Map<String, dynamic> json) {
    return EmployeeWithVouchersModel(
      employeeId: json['employeeId'] as int? ?? 0,
      employeeName: json['employeeName'] as String? ?? '',
      areaOfLocation: (json['areaOfLocation'] as String?) ??
          (json['area'] as String?) ??
          (json['location'] as String?) ??
          '',
      hotel: json['hotel'] as String?,
      voucherCount: json['voucherCount'] as int? ?? 0,
    );
  }
}

class EmployeesWithVouchersModel extends EmployeesWithVouchersEntity {
  const EmployeesWithVouchersModel({
    required super.employees,
    required super.totalEmployees,
    required super.totalVouchers,
  });

  factory EmployeesWithVouchersModel.fromJson(Map<String, dynamic> json) {
    final employeesData = json['employees'] as List<dynamic>? ?? [];
    return EmployeesWithVouchersModel(
      employees: employeesData
          .map((item) => EmployeeWithVouchersModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalEmployees: json['totalEmployees'] as int? ?? 0,
      totalVouchers: json['totalVouchers'] as int? ?? 0,
    );
  }
}

