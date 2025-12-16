import 'package:the_dunes/features/pickup_times/domain/entities/vehicle_group_entity.dart';
import 'package:the_dunes/features/pickup_times/data/models/pickup_booking_model.dart';
import 'package:the_dunes/features/pickup_times/data/models/pickup_voucher_model.dart';

class VehicleGroupModel extends VehicleGroupEntity {
  VehicleGroupModel({
    required super.pickupGroupId,
    required super.carNumber,
    required super.driver,
    required super.bookings,
    required super.vouchers,
    required super.totalItems,
  });

  factory VehicleGroupModel.fromJson(Map<String, dynamic> json) {
    return VehicleGroupModel(
      pickupGroupId: json['pickupGroupId'] ?? '',
      carNumber: json['carNumber'] ?? 0,
      driver: json['driver'] ?? '',
      bookings: (json['bookings'] as List<dynamic>?)
              ?.map((e) => PickupBookingModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      vouchers: (json['vouchers'] as List<dynamic>?)
              ?.map((e) => PickupVoucherModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalItems: json['totalItems'] ?? 0,
    );
  }
}

