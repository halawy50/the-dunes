import 'package:equatable/equatable.dart';
import 'package:the_dunes/features/camp/domain/entities/camp_booking_entity.dart';
import 'package:the_dunes/features/camp/domain/entities/camp_voucher_entity.dart';

class CampDataEntity extends Equatable {
  final List<CampBookingEntity> bookings;
  final List<CampVoucherEntity> vouchers;

  const CampDataEntity({
    required this.bookings,
    required this.vouchers,
  });

  @override
  List<Object?> get props => [bookings, vouchers];
}

