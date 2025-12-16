import 'package:the_dunes/features/agents/domain/entities/service_agent_entity.dart';
import 'package:the_dunes/features/agents/domain/repositories/agent_repository.dart';

class CreateAgentServiceUseCase {
  final AgentRepository repository;

  CreateAgentServiceUseCase(this.repository);

  Future<ServiceAgentEntity> call({
    required int agentId,
    required int serviceId,
    int? locationId,
    required double adultPrice,
    double? childPrice,
    double? kidPrice,
  }) async {
    return await repository.createAgentService(
      agentId: agentId,
      serviceId: serviceId,
      locationId: locationId,
      adultPrice: adultPrice,
      childPrice: childPrice,
      kidPrice: kidPrice,
    );
  }
}


