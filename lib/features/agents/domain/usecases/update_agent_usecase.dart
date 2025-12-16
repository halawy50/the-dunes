import 'package:the_dunes/features/agents/domain/entities/agent_entity.dart';
import 'package:the_dunes/features/agents/domain/repositories/agent_repository.dart';

class UpdateAgentUseCase {
  final AgentRepository repository;

  UpdateAgentUseCase(this.repository);

  Future<AgentEntity> call(int id, String name) async {
    return await repository.updateAgent(id, name);
  }
}


