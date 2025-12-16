import 'package:the_dunes/features/pickup_times/domain/entities/pickup_service_entity.dart';

class PickupVoucherEntity {
  final int id;
  final String type;
  final String guestName;
  final String phoneNumber;
  final String payment;
  final String status;
  final String? pickupStatus;
  final int? pickupTime;
  final List<PickupServiceEntity> services;
  final int? room;
  final String? agentName;
  final String? location;
  final String? locationName;
  final String? hotel;
  final String? driver;
  final int? carNumber;
  final String? pickupGroupId;

  PickupVoucherEntity({
    required this.id,
    required this.type,
    required this.guestName,
    required this.phoneNumber,
    required this.payment,
    required this.status,
    this.pickupStatus,
    this.pickupTime,
    required this.services,
    this.room,
    this.agentName,
    this.location,
    this.locationName,
    this.hotel,
    this.driver,
    this.carNumber,
    this.pickupGroupId,
  });
}

