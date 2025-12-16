import 'package:the_dunes/features/pickup_times/domain/entities/pickup_booking_entity.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/pickup_voucher_entity.dart';

class VehicleGroupEntity {
  final String pickupGroupId;
  final int carNumber;
  final String driver;
  final List<PickupBookingEntity> bookings;
  final List<PickupVoucherEntity> vouchers;
  final int totalItems;

  VehicleGroupEntity({
    required this.pickupGroupId,
    required this.carNumber,
    required this.driver,
    required this.bookings,
    required this.vouchers,
    required this.totalItems,
  });
}

