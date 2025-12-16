import 'package:the_dunes/core/data/models/paginated_response.dart';
import 'package:the_dunes/features/agents/data/datasources/agent_remote_data_source.dart';
import 'package:the_dunes/features/agents/data/datasources/service_agent_remote_data_source.dart';
import 'package:the_dunes/features/agents/data/models/agent_model.dart';
import 'package:the_dunes/features/agents/data/models/agent_services_response_model.dart';
import 'package:the_dunes/features/agents/data/models/service_agent_model.dart';
import 'package:the_dunes/features/agents/domain/entities/agent_entity.dart';
import 'package:the_dunes/features/agents/domain/entities/agent_services_entity.dart';
import 'package:the_dunes/features/agents/domain/entities/service_agent_entity.dart';
import 'package:the_dunes/features/agents/domain/repositories/agent_repository.dart';

class AgentRepositoryImpl implements AgentRepository {
  final AgentRemoteDataSource dataSource;
  final ServiceAgentRemoteDataSource serviceAgentDataSource;

  AgentRepositoryImpl(this.dataSource, this.serviceAgentDataSource);

  AgentEntity _toEntity(AgentModel model) {
    return AgentEntity(id: model.id, name: model.name);
  }

  ServiceAgentEntity _serviceToEntity(ServiceAgentModel model) {
    return ServiceAgentEntity(
      id: model.id,
      agentId: model.agentId,
      serviceId: model.serviceId,
      serviceName: model.serviceName,
      locationId: model.locationId,
      locationName: model.locationName,
      adultPrice: model.adultPrice,
      childPrice: model.childPrice,
      kidPrice: model.kidPrice,
      isGlobal: model.isGlobal,
    );
  }

  AgentServicesEntity _servicesToEntity(AgentServicesResponseModel model) {
    final globalServices = model.globalServices
        .map((s) => _serviceToEntity(s))
        .toList();
    
    final locationServices = <String, List<ServiceAgentEntity>>{};
    model.locationServices.forEach((locationName, services) {
      locationServices[locationName] = services
          .map((s) => _serviceToEntity(s))
          .toList();
    });

    return AgentServicesEntity(
      agentId: model.agentId,
      agentName: model.agentName,
      globalServices: globalServices,
      locationServices: locationServices,
    );
  }

  @override
  Future<List<AgentEntity>> getAllAgents() async {
    final models = await dataSource.getAllAgents();
    return models.map((m) => _toEntity(m)).toList();
  }

  @override
  Future<AgentEntity> getAgentById(int id) async {
    final model = await dataSource.getAgentById(id);
    return _toEntity(model);
  }

  @override
  Future<AgentEntity> createAgent(String name) async {
    final model = await dataSource.createAgent(name);
    return _toEntity(model);
  }

  @override
  Future<AgentEntity> updateAgent(int id, String name) async {
    final model = await dataSource.updateAgent(id, name);
    return _toEntity(model);
  }

  @override
  Future<void> deleteAgent(int id) async {
    await dataSource.deleteAgent(id);
  }

  @override
  Future<AgentServicesEntity> getAgentServices(int agentId) async {
    final model = await dataSource.getAgentServices(agentId);
    return _servicesToEntity(model);
  }

  @override
  Future<ServiceAgentEntity> createAgentService({
    required int agentId,
    required int serviceId,
    int? locationId,
    required double adultPrice,
    double? childPrice,
    double? kidPrice,
  }) async {
    final model = await dataSource.createAgentService(
      agentId: agentId,
      serviceId: serviceId,
      locationId: locationId,
      adultPrice: adultPrice,
      childPrice: childPrice,
      kidPrice: kidPrice,
    );
    return _serviceToEntity(model);
  }

  @override
  Future<PaginatedResponse<ServiceAgentEntity>> getServiceAgents({
    int page = 1,
    int pageSize = 20,
    int? agentId,
    int? locationId,
  }) async {
    final result = await serviceAgentDataSource.getServiceAgents(
      page: page,
      pageSize: pageSize,
      agentId: agentId,
      locationId: locationId,
    );
    return PaginatedResponse<ServiceAgentEntity>(
      success: result.success,
      message: result.message,
      data: result.data.map((m) => _serviceToEntity(m)).toList(),
      pagination: result.pagination,
      totalPrice: result.totalPrice,
      totalCount: result.totalCount,
      statistics: result.statistics,
    );
  }

  @override
  Future<List<ServiceAgentEntity>> getAllServiceAgents({
    int? agentId,
    int? locationId,
  }) async {
    final models = await serviceAgentDataSource.getAllServiceAgents(
      agentId: agentId,
      locationId: locationId,
    );
    return models.map((m) => _serviceToEntity(m)).toList();
  }

  @override
  Future<ServiceAgentEntity> getServiceAgentById(int id) async {
    final model = await serviceAgentDataSource.getServiceAgentById(id);
    return _serviceToEntity(model);
  }

  @override
  Future<ServiceAgentEntity> updateServiceAgent({
    required int id,
    int? agentId,
    int? locationId,
    int? serviceId,
    double? adultPrice,
    double? childPrice,
    double? kidPrice,
  }) async {
    final model = await serviceAgentDataSource.updateServiceAgent(
      id: id,
      agentId: agentId,
      locationId: locationId,
      serviceId: serviceId,
      adultPrice: adultPrice,
      childPrice: childPrice,
      kidPrice: kidPrice,
    );
    return _serviceToEntity(model);
  }

  @override
  Future<void> deleteServiceAgent(int id) async {
    await serviceAgentDataSource.deleteServiceAgent(id);
  }
}

