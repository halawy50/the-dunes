import 'package:the_dunes/core/data/models/paginated_response.dart';
import 'package:the_dunes/core/network/api_client.dart';
import 'package:the_dunes/core/network/api_constants.dart';
import 'package:the_dunes/core/network/api_exception.dart';
import 'package:the_dunes/features/agents/data/models/service_agent_model.dart';

abstract class ServiceAgentRemoteDataSource {
  Future<PaginatedResponse<ServiceAgentModel>> getServiceAgents({
    int page = 1,
    int pageSize = 20,
    int? agentId,
    int? locationId,
  });
  Future<List<ServiceAgentModel>> getAllServiceAgents({
    int? agentId,
    int? locationId,
  });
  Future<ServiceAgentModel> getServiceAgentById(int id);
  Future<ServiceAgentModel> updateServiceAgent({
    required int id,
    int? agentId,
    int? locationId,
    int? serviceId,
    double? adultPrice,
    double? childPrice,
    double? kidPrice,
  });
  Future<void> deleteServiceAgent(int id);
}

class ServiceAgentRemoteDataSourceImpl
    implements ServiceAgentRemoteDataSource {
  final ApiClient apiClient;

  ServiceAgentRemoteDataSourceImpl(this.apiClient);

  @override
  Future<PaginatedResponse<ServiceAgentModel>> getServiceAgents({
    int page = 1,
    int pageSize = 20,
    int? agentId,
    int? locationId,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };
      if (agentId != null) {
        queryParams['agentId'] = agentId.toString();
      }
      if (locationId != null) {
        queryParams['locationId'] = locationId.toString();
      }
      final response = await apiClient.get(
        ApiConstants.serviceAgentsEndpoint,
        queryParams: queryParams,
      );
      return PaginatedResponse.fromJson(
        response,
        (json) => ServiceAgentModel.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<List<ServiceAgentModel>> getAllServiceAgents({
    int? agentId,
    int? locationId,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (agentId != null) {
        queryParams['agentId'] = agentId.toString();
      }
      if (locationId != null) {
        queryParams['locationId'] = locationId.toString();
      }
      final response = await apiClient.get(
        ApiConstants.serviceAgentsAllEndpoint,
        queryParams: queryParams.isEmpty ? null : queryParams,
      );
      final data = response['data'] as List<dynamic>? ?? [];
      return data
          .map((json) => ServiceAgentModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<ServiceAgentModel> getServiceAgentById(int id) async {
    try {
      final response = await apiClient.get(
        ApiConstants.serviceAgentByIdEndpoint(id),
      );
      return ServiceAgentModel.fromJson(response['data']);
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<ServiceAgentModel> updateServiceAgent({
    required int id,
    int? agentId,
    int? locationId,
    int? serviceId,
    double? adultPrice,
    double? childPrice,
    double? kidPrice,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (agentId != null) body['agentId'] = agentId;
      if (locationId != null) body['locationId'] = locationId;
      if (serviceId != null) body['serviceId'] = serviceId;
      if (adultPrice != null) body['adultPrice'] = adultPrice;
      if (childPrice != null) body['childPrice'] = childPrice;
      if (kidPrice != null) body['kidPrice'] = kidPrice;
      final response = await apiClient.put(
        ApiConstants.serviceAgentByIdEndpoint(id),
        body,
      );
      return ServiceAgentModel.fromJson(response['data']);
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<void> deleteServiceAgent(int id) async {
    try {
      await apiClient.delete(ApiConstants.serviceAgentByIdEndpoint(id));
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }
}


