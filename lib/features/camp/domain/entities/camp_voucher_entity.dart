import 'package:equatable/equatable.dart';
import 'package:the_dunes/features/camp/domain/entities/camp_service_entity.dart';

class CampVoucherEntity extends Equatable {
  final int id;
  final String guestName;
  final String? phoneNumber;
  final String? location;
  final String? hotel;
  final int? room;
  final String status;
  final int? pickupTime;
  final String? driver;
  final int? carNumber;
  final String? note;
  final String typeOperation;
  final double finalPriceWithCommissionEmployee;
  final double finalPriceAfterDeductingCommissionEmployee;
  final List<CampServiceEntity> services;

  const CampVoucherEntity({
    required this.id,
    required this.guestName,
    this.phoneNumber,
    this.location,
    this.hotel,
    this.room,
    required this.status,
    this.pickupTime,
    this.driver,
    this.carNumber,
    this.note,
    required this.typeOperation,
    required this.finalPriceWithCommissionEmployee,
    required this.finalPriceAfterDeductingCommissionEmployee,
    this.services = const [],
  });

  @override
  List<Object?> get props => [
        id,
        guestName,
        phoneNumber,
        location,
        hotel,
        room,
        status,
        pickupTime,
        driver,
        carNumber,
        note,
        typeOperation,
        finalPriceWithCommissionEmployee,
        finalPriceAfterDeductingCommissionEmployee,
        services,
      ];
}

