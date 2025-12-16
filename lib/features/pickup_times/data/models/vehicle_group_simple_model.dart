import 'package:the_dunes/features/pickup_times/domain/entities/vehicle_group_simple_entity.dart';

class VehicleGroupSimpleModel extends VehicleGroupSimpleEntity {
  VehicleGroupSimpleModel({
    required super.pickupGroupId,
    super.carNumber,
    super.driver,
    required super.totalItems,
  });

  factory VehicleGroupSimpleModel.fromJson(Map<String, dynamic> json) {
    return VehicleGroupSimpleModel(
      pickupGroupId: json['pickupGroupId'] ?? '',
      carNumber: json['carNumber'] as int?,
      driver: json['driver'] as String?,
      totalItems: json['totalItems'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pickupGroupId': pickupGroupId,
      'carNumber': carNumber,
      'driver': driver,
      'totalItems': totalItems,
    };
  }
}

