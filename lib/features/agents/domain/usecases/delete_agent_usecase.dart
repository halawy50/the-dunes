import 'package:the_dunes/features/agents/domain/repositories/agent_repository.dart';

class DeleteAgentUseCase {
  final AgentRepository repository;

  DeleteAgentUseCase(this.repository);

  Future<void> call(int id) async {
    return await repository.deleteAgent(id);
  }
}


