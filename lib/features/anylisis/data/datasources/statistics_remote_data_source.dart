import 'package:the_dunes/core/network/api_client.dart';
import 'package:the_dunes/core/network/api_constants.dart';
import 'package:the_dunes/core/network/api_exception.dart';
import 'package:the_dunes/features/anylisis/data/models/bookings_by_agency_model.dart';
import 'package:the_dunes/features/anylisis/data/models/dashboard_summary_model.dart';
import 'package:the_dunes/features/anylisis/data/models/employee_with_vouchers_model.dart';
import 'package:the_dunes/features/anylisis/data/models/statistics_model.dart';

class StatisticsRemoteDataSource {
  final ApiClient apiClient;

  StatisticsRemoteDataSource(this.apiClient);

  Future<StatisticsModel> getStatistics({
    int? startDate,
    int? endDate,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toString();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toString();
      }
      final uri = Uri.parse(ApiConstants.statisticsEndpoint)
          .replace(queryParameters: queryParams);
      final response = await apiClient.get(uri.toString());
      return StatisticsModel.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<DashboardSummaryModel> getDashboardSummary({
    int? startDate,
    int? endDate,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toString();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toString();
      }
      final uri = Uri.parse(ApiConstants.statisticsDashboardSummaryEndpoint)
          .replace(queryParameters: queryParams);
      final response = await apiClient.get(uri.toString());
      final data = response['data'];
      if (data == null) {
        throw ApiException(message: 'Data is null', statusCode: 500);
      }
      return DashboardSummaryModel.fromJson(data as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<BookingsByAgencyModel> getBookingsByAgency({
    int? startDate,
    int? endDate,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toString();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toString();
      }
      final uri = Uri.parse(ApiConstants.statisticsBookingsByAgencyEndpoint)
          .replace(queryParameters: queryParams);
      final response = await apiClient.get(uri.toString());
      final data = response['data'];
      if (data == null) {
        throw ApiException(message: 'Data is null', statusCode: 500);
      }
      return BookingsByAgencyModel.fromJson(data as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<EmployeesWithVouchersModel> getEmployeesWithVouchers({
    int? startDate,
    int? endDate,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toString();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toString();
      }
      final uri = Uri.parse(ApiConstants.statisticsEmployeesWithVouchersEndpoint)
          .replace(queryParameters: queryParams);
      final response = await apiClient.get(uri.toString());
      final data = response['data'];
      if (data == null) {
        throw ApiException(message: 'Data is null', statusCode: 500);
      }
      return EmployeesWithVouchersModel.fromJson(data as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }
}

