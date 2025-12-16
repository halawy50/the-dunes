import 'package:the_dunes/features/camp/data/models/camp_booking_model.dart';
import 'package:the_dunes/features/camp/data/models/camp_voucher_model.dart';
import 'package:the_dunes/features/camp/domain/entities/camp_data_entity.dart';

class CampDataModel extends CampDataEntity {
  CampDataModel({
    required super.bookings,
    required super.vouchers,
  });

  factory CampDataModel.fromJson(Map<String, dynamic> json) {
    final bookingsData = json['bookings'] as List<dynamic>? ?? [];
    final vouchersData = json['vouchers'] as List<dynamic>? ?? [];

    return CampDataModel(
      bookings: bookingsData
          .map((item) => CampBookingModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      vouchers: vouchersData
          .map((item) => CampVoucherModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookings': bookings.map((e) => (e as CampBookingModel).toJson()).toList(),
      'vouchers': vouchers.map((e) => (e as CampVoucherModel).toJson()).toList(),
    };
  }
}

