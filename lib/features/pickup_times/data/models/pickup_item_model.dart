import 'package:the_dunes/features/pickup_times/domain/entities/pickup_item_entity.dart';
import 'package:the_dunes/features/pickup_times/data/models/pickup_booking_model.dart';
import 'package:the_dunes/features/pickup_times/data/models/pickup_voucher_model.dart';

class PickupItemModel extends PickupItemEntity {
  PickupItemModel({
    required super.type,
    super.booking,
    super.voucher,
  });

  factory PickupItemModel.fromJson(Map<String, dynamic> json) {
    return PickupItemModel(
      type: json['type'] ?? '',
      booking: json['booking'] != null
          ? PickupBookingModel.fromJson(json['booking'] as Map<String, dynamic>)
          : null,
      voucher: json['voucher'] != null
          ? PickupVoucherModel.fromJson(json['voucher'] as Map<String, dynamic>)
          : null,
    );
  }
}

