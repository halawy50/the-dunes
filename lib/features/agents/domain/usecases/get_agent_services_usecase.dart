import 'package:the_dunes/features/agents/domain/entities/agent_services_entity.dart';
import 'package:the_dunes/features/agents/domain/repositories/agent_repository.dart';

class GetAgentServicesUseCase {
  final AgentRepository repository;

  GetAgentServicesUseCase(this.repository);

  Future<AgentServicesEntity> call(int agentId) async {
    return await repository.getAgentServices(agentId);
  }
}


