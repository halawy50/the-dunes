import 'package:the_dunes/features/camp/domain/entities/camp_service_entity.dart';

class CampServiceModel extends CampServiceEntity {
  const CampServiceModel({
    required super.id,
    required super.serviceId,
    super.serviceName,
    required super.adultNumber,
    required super.childNumber,
    required super.kidNumber,
    required super.adultPrice,
    required super.childPrice,
    required super.kidPrice,
    required super.totalPrice,
  });

  factory CampServiceModel.fromJson(Map<String, dynamic> json) {
    return CampServiceModel(
      id: json['id'] as int? ?? 0,
      serviceId: json['serviceId'] as int? ?? 0,
      serviceName: json['serviceName'] as String?,
      adultNumber: json['adultNumber'] as int? ?? 0,
      childNumber: json['childNumber'] as int? ?? 0,
      kidNumber: json['kidNumber'] as int? ?? 0,
      adultPrice: (json['adultPrice'] as num?)?.toDouble() ?? 0.0,
      childPrice: (json['childPrice'] as num?)?.toDouble() ?? 0.0,
      kidPrice: (json['kidPrice'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['totalPriceService'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'adultNumber': adultNumber,
      'childNumber': childNumber,
      'kidNumber': kidNumber,
      'adultPrice': adultPrice,
      'childPrice': childPrice,
      'kidPrice': kidPrice,
      'totalPrice': totalPrice,
    };
  }
}

