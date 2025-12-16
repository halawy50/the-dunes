import 'package:the_dunes/features/agents/domain/repositories/agent_repository.dart';

class DeleteServiceAgentUseCase {
  final AgentRepository repository;

  DeleteServiceAgentUseCase(this.repository);

  Future<void> call(int id) async {
    return await repository.deleteServiceAgent(id);
  }
}


