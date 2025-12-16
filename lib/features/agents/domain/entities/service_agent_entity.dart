class ServiceAgentEntity {
  final int id;
  final int agentId;
  final int serviceId;
  final String? serviceName;
  final int? locationId;
  final String? locationName;
  final double adultPrice;
  final double? childPrice;
  final double? kidPrice;
  final bool isGlobal;

  ServiceAgentEntity({
    required this.id,
    required this.agentId,
    required this.serviceId,
    this.serviceName,
    this.locationId,
    this.locationName,
    required this.adultPrice,
    this.childPrice,
    this.kidPrice,
    this.isGlobal = false,
  });
}


