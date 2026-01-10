import 'package:equatable/equatable.dart';
import 'package:the_dunes/features/camp/domain/entities/camp_service_entity.dart';

class CampBookingEntity extends Equatable {
  final int id;
  final String guestName;
  final String? phoneNumber;
  final String? hotelName;
  final int? room;
  final int agentName;
  final String? agentNameStr;
  final String statusBook;
  final String? pickupTime;
  final String? driver;
  final int? carNumber;
  final String? note;
  final String typeOperation;
  final double finalPrice;
  final List<CampServiceEntity> services;

  const CampBookingEntity({
    required this.id,
    required this.guestName,
    this.phoneNumber,
    this.hotelName,
    this.room,
    required this.agentName,
    this.agentNameStr,
    required this.statusBook,
    this.pickupTime,
    this.driver,
    this.carNumber,
    this.note,
    required this.typeOperation,
    required this.finalPrice,
    this.services = const [],
  });

  @override
  List<Object?> get props => [
        id,
        guestName,
        phoneNumber,
        hotelName,
        room,
        agentName,
        agentNameStr,
        statusBook,
        pickupTime,
        driver,
        carNumber,
        note,
        typeOperation,
        finalPrice,
        services,
      ];
}

