import 'package:equatable/equatable.dart';

class EmployeeWithVouchersEntity extends Equatable {
  final int employeeId;
  final String employeeName;
  final String areaOfLocation;
  final String? hotel;
  final int voucherCount;

  const EmployeeWithVouchersEntity({
    required this.employeeId,
    required this.employeeName,
    required this.areaOfLocation,
    this.hotel,
    required this.voucherCount,
  });

  @override
  List<Object?> get props => [employeeId, employeeName, areaOfLocation, hotel, voucherCount];
}

class EmployeesWithVouchersEntity extends Equatable {
  final List<EmployeeWithVouchersEntity> employees;
  final int totalEmployees;
  final int totalVouchers;

  const EmployeesWithVouchersEntity({
    required this.employees,
    required this.totalEmployees,
    required this.totalVouchers,
  });

  @override
  List<Object?> get props => [employees, totalEmployees, totalVouchers];
}

