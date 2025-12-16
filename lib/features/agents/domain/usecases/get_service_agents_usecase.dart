import 'package:the_dunes/core/data/models/paginated_response.dart';
import 'package:the_dunes/features/agents/domain/entities/service_agent_entity.dart';
import 'package:the_dunes/features/agents/domain/repositories/agent_repository.dart';

class GetServiceAgentsUseCase {
  final AgentRepository repository;

  GetServiceAgentsUseCase(this.repository);

  Future<PaginatedResponse<ServiceAgentEntity>> call({
    int page = 1,
    int pageSize = 20,
    int? agentId,
    int? locationId,
  }) async {
    return await repository.getServiceAgents(
      page: page,
      pageSize: pageSize,
      agentId: agentId,
      locationId: locationId,
    );
  }
}


