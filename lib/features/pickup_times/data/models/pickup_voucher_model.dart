import 'package:the_dunes/features/pickup_times/domain/entities/pickup_voucher_entity.dart';
import 'package:the_dunes/features/pickup_times/data/models/pickup_service_model.dart';

class PickupVoucherModel extends PickupVoucherEntity {
  PickupVoucherModel({
    required super.id,
    required super.type,
    required super.guestName,
    required super.phoneNumber,
    required super.payment,
    required super.status,
    super.pickupStatus,
    super.pickupTime,
    required super.services,
    super.room,
    super.agentName,
    super.location,
    super.locationName,
    super.hotel,
    super.driver,
    super.carNumber,
    super.pickupGroupId,
  });

  factory PickupVoucherModel.fromJson(Map<String, dynamic> json) {
    return PickupVoucherModel(
      id: json['id'] ?? 0,
      type: json['type'] ?? 'voucher',
      guestName: json['guestName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      payment: json['payment'] ?? '',
      status: json['status'] ?? '',
      pickupStatus: json['pickupStatus'],
      pickupTime: json['pickupTime'],
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => PickupServiceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      room: json['room'],
      agentName: json['agentName'],
      location: json['location'],
      locationName: json['locationName'],
      hotel: json['hotel'],
      driver: json['driver'],
      carNumber: json['carNumber'],
      pickupGroupId: json['pickupGroupId'],
    );
  }
}

