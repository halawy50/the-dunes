import 'package:the_dunes/features/agents/domain/entities/service_agent_entity.dart';
import 'package:the_dunes/features/agents/domain/repositories/agent_repository.dart';

class GetServiceAgentByIdUseCase {
  final AgentRepository repository;

  GetServiceAgentByIdUseCase(this.repository);

  Future<ServiceAgentEntity> call(int id) async {
    return await repository.getServiceAgentById(id);
  }
}


