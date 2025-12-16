import 'package:the_dunes/core/network/api_client.dart';
import 'package:the_dunes/core/network/api_constants.dart';
import 'package:the_dunes/core/network/api_exception.dart';
import 'package:the_dunes/features/agents/data/models/agent_model.dart';
import 'package:the_dunes/features/agents/data/models/agent_services_response_model.dart';
import 'package:the_dunes/features/agents/data/models/service_agent_model.dart';

abstract class AgentRemoteDataSource {
  Future<List<AgentModel>> getAllAgents();
  Future<AgentModel> getAgentById(int id);
  Future<AgentModel> createAgent(String name);
  Future<AgentModel> updateAgent(int id, String name);
  Future<void> deleteAgent(int id);
  Future<AgentServicesResponseModel> getAgentServices(int agentId);
  Future<ServiceAgentModel> createAgentService({
    required int agentId,
    required int serviceId,
    int? locationId,
    required double adultPrice,
    double? childPrice,
    double? kidPrice,
  });
}

class AgentRemoteDataSourceImpl implements AgentRemoteDataSource {
  final ApiClient apiClient;

  AgentRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<AgentModel>> getAllAgents() async {
    try {
      final response = await apiClient.get(ApiConstants.agentsAllEndpoint);
      final data = response['data'] as List<dynamic>? ?? [];
      return data.map((json) => AgentModel.fromJson(json)).toList();
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<AgentModel> getAgentById(int id) async {
    try {
      final response = await apiClient.get(ApiConstants.agentByIdEndpoint(id));
      return AgentModel.fromJson(response['data']);
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<AgentModel> createAgent(String name) async {
    try {
      final response = await apiClient.post(
        ApiConstants.agentsEndpoint,
        {'name': name},
      );
      return AgentModel.fromJson(response['data']);
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<AgentModel> updateAgent(int id, String name) async {
    try {
      final response = await apiClient.put(
        ApiConstants.agentByIdEndpoint(id),
        {'name': name},
      );
      return AgentModel.fromJson(response['data']);
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<void> deleteAgent(int id) async {
    try {
      await apiClient.delete(ApiConstants.agentByIdEndpoint(id));
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<AgentServicesResponseModel> getAgentServices(int agentId) async {
    try {
      final response = await apiClient.get(
        ApiConstants.agentServicesEndpoint(agentId),
      );
      return AgentServicesResponseModel.fromJson(response['data']);
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<ServiceAgentModel> createAgentService({
    required int agentId,
    required int serviceId,
    int? locationId,
    required double adultPrice,
    double? childPrice,
    double? kidPrice,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.agentServicesEndpoint(agentId),
        {
          'agentId': agentId,
          'serviceId': serviceId,
          'locationId': locationId,
          'adultPrice': adultPrice,
          'childPrice': childPrice,
          'kidPrice': kidPrice,
        },
      );
      return ServiceAgentModel.fromJson(response['data']);
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }
}

