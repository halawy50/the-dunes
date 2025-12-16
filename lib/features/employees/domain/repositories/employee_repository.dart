import 'dart:typed_data';
import 'package:the_dunes/core/data/models/paginated_response.dart';
import 'package:the_dunes/features/employees/domain/entities/commission_entity.dart';
import 'package:the_dunes/features/employees/domain/entities/employee_entity.dart';
import 'package:the_dunes/features/employees/domain/entities/salary_entity.dart';

abstract class EmployeeRepository {
  Future<PaginatedResponse<EmployeeEntity>> getEmployees({
    int page = 1,
    int pageSize = 20,
  });

  Future<EmployeeEntity> getEmployeeById(int id);

  Future<EmployeeEntity> createEmployee(
    Map<String, dynamic> data, {
    Map<String, Uint8List>? files,
  });

  Future<EmployeeEntity> updateEmployee(int id, Map<String, dynamic> data);

  Future<void> deleteEmployee(int id);

  Future<List<SalaryEntity>> getEmployeeSalaries(
    int employeeId, {
    String? year,
    String? month,
  });

  Future<List<SalaryEntity>> getEmployeePendingSalaries(int employeeId);

  Future<List<CommissionEntity>> getEmployeeCommissions(
    int employeeId, {
    String? status,
  });

  Future<Map<String, dynamic>> getEmployeePendingCommissions(int employeeId);

  Future<Map<String, dynamic>> resetPassword({
    int? employeeId,
    String? email,
    required String newPassword,
  });
}


