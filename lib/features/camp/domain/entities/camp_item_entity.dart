import 'package:equatable/equatable.dart';
import 'package:the_dunes/features/camp/domain/entities/camp_booking_entity.dart';
import 'package:the_dunes/features/camp/domain/entities/camp_service_entity.dart';
import 'package:the_dunes/features/camp/domain/entities/camp_voucher_entity.dart';

class CampItemEntity extends Equatable {
  final CampBookingEntity? booking;
  final CampVoucherEntity? voucher;
  final bool isBooking;

  const CampItemEntity({
    this.booking,
    this.voucher,
  }) : isBooking = booking != null;

  int get id => isBooking ? booking!.id : voucher!.id;
  String get guestName => isBooking ? booking!.guestName : voucher!.guestName;
  String? get phoneNumber => isBooking ? booking!.phoneNumber : voucher!.phoneNumber;
  String? get hotel => isBooking ? booking!.hotelName : voucher!.hotel;
  int? get room => isBooking ? booking!.room : voucher!.room;
  String? get location => isBooking ? null : voucher!.location;
  String? get pickupTime => isBooking ? booking!.pickupTime : (voucher!.pickupTime?.toString());
  String? get driver => isBooking ? booking!.driver : voucher!.driver;
  int? get carNumber => isBooking ? booking!.carNumber : voucher!.carNumber;
  double get price => isBooking ? booking!.finalPrice : voucher!.finalPriceAfterDeductingCommissionEmployee;
  List<CampServiceEntity> get services => isBooking ? booking!.services : voucher!.services;

  @override
  List<Object?> get props => [booking, voucher, isBooking];
}

