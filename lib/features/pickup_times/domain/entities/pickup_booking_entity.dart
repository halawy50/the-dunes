import 'package:the_dunes/features/pickup_times/domain/entities/pickup_service_entity.dart';

class PickupBookingEntity {
  final int id;
  final String type;
  final String guestName;
  final String phoneNumber;
  final String payment;
  final String statusBook;
  final String? pickupStatus;
  final String? pickupTime;
  final List<PickupServiceEntity> services;
  final int? room;
  final int? agentId;
  final String? agentName;
  final String? location;
  final String? locationName;
  final String? hotelName;
  final String? driver;
  final int? carNumber;
  final String? pickupGroupId;

  PickupBookingEntity({
    required this.id,
    required this.type,
    required this.guestName,
    required this.phoneNumber,
    required this.payment,
    required this.statusBook,
    this.pickupStatus,
    this.pickupTime,
    required this.services,
    this.room,
    this.agentId,
    this.agentName,
    this.location,
    this.locationName,
    this.hotelName,
    this.driver,
    this.carNumber,
    this.pickupGroupId,
  });
}

