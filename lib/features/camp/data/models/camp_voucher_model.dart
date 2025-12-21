import 'package:the_dunes/features/camp/data/models/camp_service_model.dart';
import 'package:the_dunes/features/camp/domain/entities/camp_voucher_entity.dart';

class CampVoucherModel extends CampVoucherEntity {
  const CampVoucherModel({
    required super.id,
    required super.guestName,
    super.phoneNumber,
    super.location,
    super.hotel,
    super.room,
    required super.status,
    super.pickupTime,
    super.driver,
    super.carNumber,
    super.note,
    required super.typeOperation,
    required super.finalPriceWithCommissionEmployee,
    required super.finalPriceAfterDeductingCommissionEmployee,
    super.services,
  });

  factory CampVoucherModel.fromJson(Map<String, dynamic> json) {
    final servicesData = json['services'] as List<dynamic>? ?? [];
    return CampVoucherModel(
      id: json['id'] as int? ?? 0,
      guestName: json['guestName'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String?,
      location: json['location'] as String?,
      hotel: json['hotel'] as String?,
      room: json['room'] as int?,
      status: json['status'] as String? ?? '',
      pickupTime: json['pickupTime'] as int?,
      driver: json['driver'] as String?,
      carNumber: json['carNumber'] as int?,
      note: json['note'] as String?,
      typeOperation: json['typeOperation'] as String? ?? '',
      finalPriceWithCommissionEmployee:
          (json['finalPriceWithCommissionEmployee'] as num?)?.toDouble() ?? 0.0,
      finalPriceAfterDeductingCommissionEmployee:
          (json['finalPriceAfterDeductingCommissionEmployee'] as num?)?.toDouble() ?? 0.0,
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
      'location': location,
      'hotel': hotel,
      'room': room,
      'status': status,
      'pickupTime': pickupTime,
      'driver': driver,
      'carNumber': carNumber,
      'note': note,
      'typeOperation': typeOperation,
      'finalPriceWithCommissionEmployee': finalPriceWithCommissionEmployee,
      'finalPriceAfterDeductingCommissionEmployee':
          finalPriceAfterDeductingCommissionEmployee,
      'services': services.map((e) => (e as CampServiceModel).toJson()).toList(),
    };
  }
}

