import 'package:flutter/material.dart';
import 'package:the_dunes/core/widgets/base_table/booking/booking_status_dropdown_cell.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/pickup_times/presentation/models/pickup_table_item.dart';

class PickupTimesTableHelpers {
  static Widget buildStatusDropdown(
    PickupTableItem item,
    void Function(PickupTableItem, String newStatus, String statusType) onItemStatusUpdate,
    bool isLoading,
  ) {
    final statuses = ['PENDING', 'ACCEPTED', 'COMPLETED', 'CANCELLED'];
    return BookingStatusDropdownCell(
      key: ValueKey('status_${item.id}_${item.status}'),
      value: item.status,
      items: statuses,
      isLoading: isLoading,
      onChanged: (newStatus) {
        if (newStatus != null && newStatus != item.status && !isLoading) {
          onItemStatusUpdate(item, newStatus, 'bookingStatus');
        }
      },
      getColor: _getStatusBookColor,
    );
  }

  static Widget buildPickupStatusDropdown(
    PickupTableItem item,
    void Function(PickupTableItem, String newStatus, String statusType) onItemStatusUpdate,
    bool isLoading,
  ) {
    final statuses = ['YET', 'PICKED', 'INWAY', 'DELIVERED'];
    final currentStatus = item.pickupStatus ?? 'YET';
    return BookingStatusDropdownCell(
      key: ValueKey('pickup_status_${item.id}_$currentStatus'),
      value: currentStatus,
      items: statuses,
      isLoading: isLoading,
      onChanged: (newStatus) {
        if (newStatus != null && newStatus != currentStatus && !isLoading) {
          onItemStatusUpdate(item, newStatus, 'pickupStatus');
        }
      },
      getColor: _getPickupStatusColor,
    );
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

  static Color _getPickupStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PICKED':
        return Colors.green.shade50;
      case 'YET':
        return Colors.grey.shade200;
      case 'INWAY':
        return Colors.blue.shade50;
      case 'DELIVERED':
        return Colors.green.shade100;
      default:
        return AppColor.GRAY_DARK;
    }
  }
}

