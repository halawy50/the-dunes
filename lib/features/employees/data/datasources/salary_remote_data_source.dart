import 'package:the_dunes/core/data/models/paginated_response.dart';
import 'package:the_dunes/core/network/api_client.dart';
import 'package:the_dunes/core/network/api_constants.dart';
import 'package:the_dunes/core/network/api_exception.dart';
import 'package:the_dunes/features/employees/data/models/salary_model.dart';

class SalaryRemoteDataSource {
  final ApiClient apiClient;

  SalaryRemoteDataSource(this.apiClient);

  Future<PaginatedResponse<SalaryModel>> getSalaries({
    int? employeeId,
    String? status,
    String? year,
    String? month,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };
      if (employeeId != null) queryParams['employeeId'] = employeeId.toString();
      if (status != null) queryParams['status'] = status;
      if (year != null) queryParams['year'] = year;
      if (month != null) queryParams['month'] = month;
      final response = await apiClient.get(
        ApiConstants.salariesEndpoint,
        queryParams: queryParams,
      );
      return PaginatedResponse.fromJson(
        response,
        (json) => SalaryModel.fromJson(json as Map<String, dynamic>),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<SalaryModel> getSalaryById(int id) async {
    try {
      final response = await apiClient.get(
        ApiConstants.salaryByIdEndpoint(id),
      );
      return SalaryModel.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<SalaryModel> createSalary(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.post(
        ApiConstants.salariesEndpoint,
        data,
      );
      return SalaryModel.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<SalaryModel> updateSalary(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await apiClient.put(
        ApiConstants.salaryByIdEndpoint(id),
        data,
      );
      return SalaryModel.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<SalaryModel> paySalary(int id) async {
    try {
      final response = await apiClient.post(
        ApiConstants.salaryPayEndpoint(id),
        <String, dynamic>{},
      );
      return SalaryModel.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<void> deleteSalary(int id) async {
    try {
      await apiClient.delete(ApiConstants.salaryByIdEndpoint(id));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }
}

