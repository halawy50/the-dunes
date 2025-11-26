import 'package:flutter/material.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_cell_factory.dart';
import 'package:the_dunes/core/widgets/base_table/booking/booking_status_dropdown_cell.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/booking/data/models/booking_model.dart';

class BookingTableHelpers {
  static Widget buildStatusCell(String? status) {
    final statusUpper = status?.toUpperCase();
    final isYet = statusUpper == 'YET';
    return BaseTableCellFactory.status(
      status: status ?? '-',
      color: _getStatusColor(status),
      textStyle: TextStyle(
        fontSize: 12,
        color: isYet ? AppColor.BLACK : AppColor.WHITE,
      ),
    );
  }

  static Widget buildStatusBookCell(String status) {
    return BaseTableCellFactory.status(
      status: status,
      color: _getStatusBookColor(status),
    );
  }

  static Widget buildStatusBookDropdown(
    BookingModel booking,
    void Function(BookingModel, Map<String, dynamic>) onBookingEdit,
    bool isLoading,
  ) {
    final statuses = ['PENDING', 'ACCEPTED', 'COMPLETED', 'CANCELLED'];
    return BookingStatusDropdownCell(
      value: booking.statusBook,
      items: statuses,
      isLoading: isLoading,
      onChanged: (newStatus) {
        if (newStatus != null && newStatus != booking.statusBook && !isLoading) {
          onBookingEdit(booking, {'statusBook': newStatus});
        }
      },
      getColor: _getStatusBookColor,
    );
  }

  static Widget buildPickupStatusDropdown(
    BookingModel booking,
    void Function(BookingModel, Map<String, dynamic>) onBookingEdit,
    bool isLoading,
  ) {
    final statuses = ['YET', 'PICKED', 'INWAY'];
    // إذا كان pickupStatus null أو فارغ، نستخدم 'YET' كقيمة افتراضية
    final currentStatus = booking.pickupStatus != null && booking.pickupStatus!.isNotEmpty
        ? booking.pickupStatus!
        : 'YET';
    return BookingStatusDropdownCell(
      value: currentStatus,
      items: statuses,
      isLoading: isLoading,
      onChanged: (newStatus) {
        if (newStatus != null && newStatus != currentStatus && !isLoading) {
          onBookingEdit(booking, {'pickupStatus': newStatus});
        }
      },
      getColor: (status) => _getStatusColor(status),
    );
  }

  static Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'PICKED':
        return Colors.green.shade50;
      case 'YET':
        return Colors.grey.shade200;
      case 'INWAY':
        return Colors.blue.shade50;
      default:
        return AppColor.GRAY_DARK;
    }
  }

  static Color _getStatusBookColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.orange.shade50;
      case 'ACCEPTED':
        return Colors.blue.shade50;
      case 'COMPLETED':
        return Colors.green.shade50;
      case 'CANCELLED':
        return Colors.red.shade50;
      default:
        return AppColor.GRAY_DARK;
    }
  }
}


