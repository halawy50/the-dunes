import 'package:the_dunes/features/pickup_times/domain/entities/pickup_booking_entity.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/pickup_voucher_entity.dart';

class PickupItemEntity {
  final String type;
  final PickupBookingEntity? booking;
  final PickupVoucherEntity? voucher;

  PickupItemEntity({
    required this.type,
    this.booking,
    this.voucher,
  });
}

