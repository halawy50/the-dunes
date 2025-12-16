import 'package:the_dunes/core/data/models/paginated_response.dart';
import 'package:the_dunes/features/agents/domain/entities/agent_entity.dart';
import 'package:the_dunes/features/agents/domain/entities/agent_services_entity.dart';
import 'package:the_dunes/features/agents/domain/entities/service_agent_entity.dart';

abstract class AgentRepository {
  Future<List<AgentEntity>> getAllAgents();
  Future<AgentEntity> getAgentById(int id);
  Future<AgentEntity> createAgent(String name);
  Future<AgentEntity> updateAgent(int id, String name);
  Future<void> deleteAgent(int id);
  Future<AgentServicesEntity> getAgentServices(int agentId);
  Future<ServiceAgentEntity> createAgentService({
    required int agentId,
    required int serviceId,
    int? locationId,
    required double adultPrice,
    double? childPrice,
    double? kidPrice,
  });
  Future<PaginatedResponse<ServiceAgentEntity>> getServiceAgents({
    int page = 1,
    int pageSize = 20,
    int? agentId,
    int? locationId,
  });
  Future<List<ServiceAgentEntity>> getAllServiceAgents({
    int? agentId,
    int? locationId,
  });
  Future<ServiceAgentEntity> getServiceAgentById(int id);
  Future<ServiceAgentEntity> updateServiceAgent({
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

