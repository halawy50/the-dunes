import 'package:the_dunes/features/agents/domain/entities/service_agent_entity.dart';
import 'package:the_dunes/features/agents/domain/repositories/agent_repository.dart';

class GetAllServiceAgentsUseCase {
  final AgentRepository repository;

  GetAllServiceAgentsUseCase(this.repository);

  Future<List<ServiceAgentEntity>> call({
    int? agentId,
    int? locationId,
  }) async {
    return await repository.getAllServiceAgents(
      agentId: agentId,
      locationId: locationId,
    );
  }
}


