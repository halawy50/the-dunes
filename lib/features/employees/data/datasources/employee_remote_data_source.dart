import 'dart:typed_data';
import 'package:the_dunes/core/data/models/paginated_response.dart';
import 'package:the_dunes/core/network/api_client.dart';
import 'package:the_dunes/core/network/api_constants.dart';
import 'package:the_dunes/core/network/api_exception.dart';
import 'package:the_dunes/features/employees/data/models/commission_model.dart';
import 'package:the_dunes/features/employees/data/models/employee_model.dart';
import 'package:the_dunes/features/employees/data/models/salary_model.dart';

class EmployeeRemoteDataSource {
  final ApiClient apiClient;

  EmployeeRemoteDataSource(this.apiClient);

  Future<PaginatedResponse<EmployeeModel>> getEmployees({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await apiClient.get(
        ApiConstants.employeesEndpoint,
        queryParams: {
          'page': page.toString(),
          'pageSize': pageSize.toString(),
        },
      );
      return PaginatedResponse.fromJson(
        response,
        (json) => EmployeeModel.fromJson(json as Map<String, dynamic>),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<EmployeeModel> getEmployeeById(int id) async {
    try {
      final response = await apiClient.get(
        ApiConstants.employeeByIdEndpoint(id),
      );
      return EmployeeModel.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<EmployeeModel> createEmployee(
    Map<String, dynamic> data, {
    Map<String, Uint8List>? files,
  }) async {
    try {
      Map<String, dynamic> response;
      
      // Always use multipart if there are files, or if we need to send form data
      // The API expects multipart/form-data for employee creation
      if (files != null && files.isNotEmpty) {
        // Use multipart/form-data for file uploads
        response = await apiClient.postMultipart(
          ApiConstants.employeesEndpoint,
          data,
          files,
        );
      } else {
        // Even without files, use multipart for form data
        // This ensures proper encoding of boolean values and special characters
        response = await apiClient.postMultipart(
          ApiConstants.employeesEndpoint,
          data,
          null, // No files
        );
      }
      return EmployeeModel.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<EmployeeModel> updateEmployee(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await apiClient.put(
        ApiConstants.employeeByIdEndpoint(id),
        data,
      );
      return EmployeeModel.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<void> deleteEmployee(int id) async {
    try {
      await apiClient.delete(ApiConstants.employeeByIdEndpoint(id));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<List<SalaryModel>> getEmployeeSalaries(
    int employeeId, {
    String? year,
    String? month,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (year != null) queryParams['year'] = year;
      if (month != null) queryParams['month'] = month;
      final response = await apiClient.get(
        ApiConstants.employeeSalariesEndpoint(employeeId),
        queryParams: queryParams,
      );
      final data = response['data'] as List;
      return data
          .map((json) => SalaryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<List<SalaryModel>> getEmployeePendingSalaries(int employeeId) async {
    try {
      final response = await apiClient.get(
        ApiConstants.employeeSalariesPendingEndpoint(employeeId),
      );
      final data = response['data'] as List;
      return data
          .map((json) => SalaryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<List<CommissionModel>> getEmployeeCommissions(
    int employeeId, {
    String? status,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (status != null) queryParams['status'] = status;
      final response = await apiClient.get(
        ApiConstants.employeeCommissionsEndpoint(employeeId),
        queryParams: queryParams,
      );
      final data = response['data'] as List;
      return data
          .map((json) => CommissionModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<Map<String, dynamic>> getEmployeePendingCommissions(
    int employeeId,
  ) async {
    try {
      final response = await apiClient.get(
        ApiConstants.employeeCommissionsPendingEndpoint(employeeId),
      );
      return response['data'] as Map<String, dynamic>;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<Map<String, dynamic>> resetPassword({
    int? employeeId,
    String? email,
    required String newPassword,
  }) async {
    try {
      final data = <String, dynamic>{
        'newPassword': newPassword,
      };
      if (employeeId != null) {
        data['employeeId'] = employeeId;
      }
      if (email != null) {
        data['email'] = email;
      }
      final response = await apiClient.post(
        ApiConstants.employeeResetPasswordEndpoint,
        data,
      );
      return response['data'] as Map<String, dynamic>;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }
}


