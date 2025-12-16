import 'package:the_dunes/core/data/models/paginated_response.dart';
import 'package:the_dunes/core/network/api_client.dart';
import 'package:the_dunes/core/network/api_constants.dart';
import 'package:the_dunes/core/network/api_exception.dart';
import 'package:the_dunes/features/employees/data/models/commission_model.dart';
import 'package:the_dunes/features/employees/data/models/bulk_pay_commission_response.dart';

class CommissionRemoteDataSource {
  final ApiClient apiClient;

  CommissionRemoteDataSource(this.apiClient);

  Future<PaginatedResponse<CommissionModel>> getCommissions({
    int? employeeId,
    String? status,
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
      final response = await apiClient.get(
        ApiConstants.commissionsEndpoint,
        queryParams: queryParams,
      );
      return PaginatedResponse.fromJson(
        response,
        (json) => CommissionModel.fromJson(json as Map<String, dynamic>),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<CommissionModel> getCommissionById(int id) async {
    try {
      final response = await apiClient.get(
        ApiConstants.commissionByIdEndpoint(id),
      );
      return CommissionModel.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<CommissionModel> createCommission(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.post(
        ApiConstants.commissionsEndpoint,
        data,
      );
      return CommissionModel.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<CommissionModel> updateCommission(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await apiClient.put(
        ApiConstants.commissionByIdEndpoint(id),
        data,
      );
      return CommissionModel.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<CommissionModel> payCommission(int id, {String? note}) async {
    try {
      final body = note != null && note.isNotEmpty ? {'note': note} : <String, dynamic>{};
      final response = await apiClient.post(
        ApiConstants.commissionPayEndpoint(id),
        body,
      );
      return CommissionModel.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<BulkPayCommissionResponse> bulkPayCommissions(
    List<int> commissionIds, {
    String? note,
  }) async {
    try {
      final body = <String, dynamic>{
        'commissionIds': commissionIds,
      };
      if (note != null && note.isNotEmpty) {
        body['note'] = note;
      }
      final response = await apiClient.post(
        ApiConstants.commissionsBulkPayEndpoint,
        body,
      );
      return BulkPayCommissionResponse.fromJson(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }
}

