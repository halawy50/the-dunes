import 'package:the_dunes/features/agents/domain/entities/agent_entity.dart';
import 'package:the_dunes/features/agents/domain/repositories/agent_repository.dart';

class CreateAgentUseCase {
  final AgentRepository repository;

  CreateAgentUseCase(this.repository);

  Future<AgentEntity> call(String name) async {
    return await repository.createAgent(name);
  }
}


