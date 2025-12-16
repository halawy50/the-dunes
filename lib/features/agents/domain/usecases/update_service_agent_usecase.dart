import 'package:the_dunes/features/agents/domain/entities/service_agent_entity.dart';
import 'package:the_dunes/features/agents/domain/repositories/agent_repository.dart';

class UpdateServiceAgentUseCase {
  final AgentRepository repository;

  UpdateServiceAgentUseCase(this.repository);

  Future<ServiceAgentEntity> call({
    required int id,
    int? agentId,
    int? locationId,
    int? serviceId,
    double? adultPrice,
    double? childPrice,
    double? kidPrice,
  }) async {
    return await repository.updateServiceAgent(
      id: id,
      agentId: agentId,
      locationId: locationId,
      serviceId: serviceId,
      adultPrice: adultPrice,
      childPrice: childPrice,
      kidPrice: kidPrice,
    );
  }
}


