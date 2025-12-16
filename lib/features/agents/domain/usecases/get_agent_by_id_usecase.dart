import 'package:the_dunes/features/agents/domain/entities/agent_entity.dart';
import 'package:the_dunes/features/agents/domain/repositories/agent_repository.dart';

class GetAgentByIdUseCase {
  final AgentRepository repository;

  GetAgentByIdUseCase(this.repository);

  Future<AgentEntity> call(int id) async {
    return await repository.getAgentById(id);
  }
}


