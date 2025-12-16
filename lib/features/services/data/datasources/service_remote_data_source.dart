import 'package:the_dunes/core/network/api_client.dart';
import 'package:the_dunes/core/network/api_constants.dart';
import 'package:the_dunes/core/network/api_exception.dart';
import 'package:the_dunes/features/services/data/models/service_model.dart';

class ServiceRemoteDataSource {
  final ApiClient apiClient;

  ServiceRemoteDataSource(this.apiClient);

  Future<List<ServiceModel>> getAllServices() async {
    try {
      final response = await apiClient.get(ApiConstants.servicesAllEndpoint);
      final data = response['data'] as List<dynamic>? ?? [];
      return data
          .map((json) => ServiceModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<ServiceModel> getServiceById(int id) async {
    try {
      final response = await apiClient.get(
        ApiConstants.serviceByIdEndpoint(id),
      );
      return ServiceModel.fromJson(
        response['data'] as Map<String, dynamic>,
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<ServiceModel> createService(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.post(
        ApiConstants.servicesEndpoint,
        data,
      );
      return ServiceModel.fromJson(
        response['data'] as Map<String, dynamic>,
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<ServiceModel> updateService(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await apiClient.put(
        ApiConstants.serviceByIdEndpoint(id),
        data,
      );
      return ServiceModel.fromJson(
        response['data'] as Map<String, dynamic>,
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<void> deleteService(int id) async {
    try {
      await apiClient.delete(ApiConstants.serviceByIdEndpoint(id));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }
}


