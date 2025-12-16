import 'dart:typed_data';
import 'package:the_dunes/core/data/models/paginated_response.dart';
import 'package:the_dunes/features/employees/data/datasources/employee_remote_data_source.dart';
import 'package:the_dunes/features/employees/domain/entities/commission_entity.dart';
import 'package:the_dunes/features/employees/domain/entities/employee_entity.dart';
import 'package:the_dunes/features/employees/domain/entities/salary_entity.dart';
import 'package:the_dunes/features/employees/domain/repositories/employee_repository.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeRemoteDataSource dataSource;

  EmployeeRepositoryImpl(this.dataSource);

  @override
  Future<PaginatedResponse<EmployeeEntity>> getEmployees({
    int page = 1,
    int pageSize = 20,
  }) async {
    final result = await dataSource.getEmployees(page: page, pageSize: pageSize);
    return PaginatedResponse<EmployeeEntity>(
      success: result.success,
      message: result.message,
      data: result.data,
      pagination: result.pagination,
    );
  }

  @override
  Future<EmployeeEntity> getEmployeeById(int id) async {
    return await dataSource.getEmployeeById(id);
  }

  @override
  Future<EmployeeEntity> createEmployee(
    Map<String, dynamic> data, {
    Map<String, Uint8List>? files,
  }) async {
    return await dataSource.createEmployee(data, files: files);
  }

  @override
  Future<EmployeeEntity> updateEmployee(
    int id,
    Map<String, dynamic> data,
  ) async {
    return await dataSource.updateEmployee(id, data);
  }

  @override
  Future<void> deleteEmployee(int id) async {
    return await dataSource.deleteEmployee(id);
  }

  @override
  Future<List<SalaryEntity>> getEmployeeSalaries(
    int employeeId, {
    String? year,
    String? month,
  }) async {
    return await dataSource.getEmployeeSalaries(
      employeeId,
      year: year,
      month: month,
    );
  }

  @override
  Future<List<SalaryEntity>> getEmployeePendingSalaries(int employeeId) async {
    return await dataSource.getEmployeePendingSalaries(employeeId);
  }

  @override
  Future<List<CommissionEntity>> getEmployeeCommissions(
    int employeeId, {
    String? status,
  }) async {
    return await dataSource.getEmployeeCommissions(
      employeeId,
      status: status,
    );
  }

  @override
  Future<Map<String, dynamic>> getEmployeePendingCommissions(
    int employeeId,
  ) async {
    return await dataSource.getEmployeePendingCommissions(employeeId);
  }

  @override
  Future<Map<String, dynamic>> resetPassword({
    int? employeeId,
    String? email,
    required String newPassword,
  }) async {
    return await dataSource.resetPassword(
      employeeId: employeeId,
      email: email,
      newPassword: newPassword,
    );
  }
}

