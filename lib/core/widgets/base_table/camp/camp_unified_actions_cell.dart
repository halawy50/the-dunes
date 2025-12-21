import 'package:flutter/material.dart';
import 'package:the_dunes/core/widgets/base_table/camp/camp_booking_actions_cell.dart';
import 'package:the_dunes/core/widgets/base_table/camp/camp_voucher_actions_cell.dart';
import 'package:the_dunes/features/camp/domain/entities/camp_item_entity.dart';

class CampUnifiedActionsCell {
  static Widget build({
    required CampItemEntity item,
    required void Function(CampItemEntity, String) onStatusUpdate,
    required bool Function(int)? isUpdatingBookingStatus,
    required String? Function(int)? getUpdatingStatus,
    required bool Function(int)? isUpdatingVoucherStatus,
    required String? Function(int)? getUpdatingVoucherStatus,
  }) {
    if (item.isBooking) {
      return CampBookingActionsCell(
        booking: item.booking!,
        onStatusUpdate: (booking, status) => onStatusUpdate(item, status),
        isUpdating: isUpdatingBookingStatus?.call(item.id) ?? false,
        updatingStatus: getUpdatingStatus?.call(item.id),
      );
    } else {
      return CampVoucherActionsCell(
        voucher: item.voucher!,
        onStatusUpdate: (voucher, status) => onStatusUpdate(item, status),
        isUpdating: isUpdatingVoucherStatus?.call(item.id) ?? false,
        updatingStatus: getUpdatingVoucherStatus?.call(item.id),
      );
    }
  }
}

