import 'package:the_dunes/features/agents/domain/entities/agent_entity.dart';
import 'package:the_dunes/features/agents/domain/repositories/agent_repository.dart';

class GetAllAgentsUseCase {
  final AgentRepository repository;

  GetAllAgentsUseCase(this.repository);

  Future<List<AgentEntity>> call() async {
    return await repository.getAllAgents();
  }
}


