class ServiceAgentModel {
  final int id;
  final int serviceId;
  final String? serviceName;
  final int? locationId;
  final String? locationName;
  final double adultPrice;
  final double? childPrice;
  final double? kidPrice;

  ServiceAgentModel({
    required this.id,
    required this.serviceId,
    this.serviceName,
    this.locationId,
    this.locationName,
    required this.adultPrice,
    this.childPrice,
    this.kidPrice,
  });

  factory ServiceAgentModel.fromJson(Map<String, dynamic> json) {
    return ServiceAgentModel(
      id: json['id'] ?? 0,
      serviceId: json['serviceId'] ?? 0,
      serviceName: json['serviceName'],
      locationId: json['locationId'],
      locationName: json['locationName'],
      adultPrice: (json['adultPrice'] ?? 0.0).toDouble(),
      childPrice: json['childPrice']?.toDouble(),
      kidPrice: json['kidPrice']?.toDouble(),
    );
  }
}


