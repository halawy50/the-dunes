import 'package:the_dunes/features/agents/data/models/service_agent_model.dart';

class AgentServicesResponseModel {
  final int agentId;
  final String agentName;
  final List<ServiceAgentModel> globalServices;
  final Map<String, List<ServiceAgentModel>> locationServices;

  AgentServicesResponseModel({
    required this.agentId,
    required this.agentName,
    required this.globalServices,
    required this.locationServices,
  });

  factory AgentServicesResponseModel.fromJson(Map<String, dynamic> json) {
    final globalServicesList = json['globalServices'] as List<dynamic>? ?? [];
    final globalServices = globalServicesList
        .map((item) => ServiceAgentModel.fromJson(item))
        .toList();

    final locationServicesMap = json['locationServices'] as Map<String, dynamic>? ?? {};
    final locationServices = <String, List<ServiceAgentModel>>{};
    
    locationServicesMap.forEach((locationName, servicesList) {
      final services = (servicesList as List<dynamic>)
          .map((item) => ServiceAgentModel.fromJson(item))
          .toList();
      locationServices[locationName] = services;
    });

    return AgentServicesResponseModel(
      agentId: json['agentId'] ?? 0,
      agentName: json['agentName'] ?? '',
      globalServices: globalServices,
      locationServices: locationServices,
    );
  }
}


