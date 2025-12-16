import 'package:the_dunes/features/pickup_times/domain/entities/pickup_booking_entity.dart';
import 'package:the_dunes/features/pickup_times/data/models/pickup_service_model.dart';

class PickupBookingModel extends PickupBookingEntity {
  PickupBookingModel({
    required super.id,
    required super.type,
    required super.guestName,
    required super.phoneNumber,
    required super.payment,
    required super.statusBook,
    super.pickupStatus,
    super.pickupTime,
    required super.services,
    super.room,
    super.agentId,
    super.agentName,
    super.location,
    super.locationName,
    super.hotelName,
    super.driver,
    super.carNumber,
    super.pickupGroupId,
  });

  factory PickupBookingModel.fromJson(Map<String, dynamic> json) {
    return PickupBookingModel(
      id: json['id'] ?? 0,
      type: json['type'] ?? 'booking',
      guestName: json['guestName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      payment: json['payment'] ?? '',
      statusBook: json['statusBook'] ?? '',
      pickupStatus: json['pickupStatus'],
      pickupTime: json['pickupTime'],
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => PickupServiceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      room: json['room'],
      agentId: json['agentId'],
      agentName: json['agentName'],
      location: json['location'],
      locationName: json['locationName'],
      hotelName: json['hotelName'],
      driver: json['driver'],
      carNumber: json['carNumber'],
      pickupGroupId: json['pickupGroupId'],
    );
  }
}

