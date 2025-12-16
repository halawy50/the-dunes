import 'package:the_dunes/features/agents/domain/entities/service_agent_entity.dart';

class AgentServicesEntity {
  final int agentId;
  final String agentName;
  final List<ServiceAgentEntity> globalServices;
  final Map<String, List<ServiceAgentEntity>> locationServices;

  AgentServicesEntity({
    required this.agentId,
    required this.agentName,
    required this.globalServices,
    required this.locationServices,
  });
}


