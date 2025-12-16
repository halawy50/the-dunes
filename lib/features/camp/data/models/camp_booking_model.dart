import 'package:the_dunes/features/camp/data/models/camp_service_model.dart';
import 'package:the_dunes/features/camp/domain/entities/camp_booking_entity.dart';

class CampBookingModel extends CampBookingEntity {
  const CampBookingModel({
    required super.id,
    required super.guestName,
    super.phoneNumber,
    super.hotelName,
    super.room,
    required super.agentName,
    required super.statusBook,
    super.pickupTime,
    super.driver,
    super.carNumber,
    super.note,
    required super.typeOperation,
    required super.finalPrice,
    super.services,
  });

  factory CampBookingModel.fromJson(Map<String, dynamic> json) {
    final servicesData = json['services'] as List<dynamic>? ?? [];
    return CampBookingModel(
      id: json['id'] as int,
      guestName: json['guestName'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      hotelName: json['hotelName'] as String?,
      room: json['room'] as int?,
      agentName: json['agentName'] as int,
      statusBook: json['statusBook'] as String,
      pickupTime: json['pickupTime'] as String?,
      driver: json['driver'] as String?,
      carNumber: json['carNumber'] as int?,
      note: json['note'] as String?,
      typeOperation: json['typeOperation'] as String,
      finalPrice: (json['finalPrice'] as num).toDouble(),
      services: servicesData
          .map((item) => CampServiceModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'guestName': guestName,
      'phoneNumber': phoneNumber,
      'hotelName': hotelName,
      'room': room,
      'agentName': agentName,
      'statusBook': statusBook,
      'pickupTime': pickupTime,
      'driver': driver,
      'carNumber': carNumber,
      'note': note,
      'typeOperation': typeOperation,
      'finalPrice': finalPrice,
      'services': services.map((e) => (e as CampServiceModel).toJson()).toList(),
    };
  }
}

