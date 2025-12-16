import 'package:the_dunes/features/pickup_times/domain/entities/pickup_service_entity.dart';

class PickupServiceModel extends PickupServiceEntity {
  PickupServiceModel({
    required super.id,
    required super.serviceId,
    required super.serviceName,
    required super.adultNumber,
    required super.childNumber,
    required super.kidNumber,
    required super.adultPrice,
    required super.childPrice,
    required super.kidPrice,
    required super.totalPrice,
  });

  factory PickupServiceModel.fromJson(Map<String, dynamic> json) {
    return PickupServiceModel(
      id: json['id'] ?? 0,
      serviceId: json['serviceId'] ?? 0,
      serviceName: json['serviceName'] ?? '',
      adultNumber: json['adultNumber'] ?? 0,
      childNumber: json['childNumber'] ?? 0,
      kidNumber: json['kidNumber'] ?? 0,
      adultPrice: (json['adultPrice'] ?? 0.0).toDouble(),
      childPrice: (json['childPrice'] ?? 0.0).toDouble(),
      kidPrice: (json['kidPrice'] ?? 0.0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
    );
  }
}

