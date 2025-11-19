import 'package:flutter/material.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_cell_factory.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class BookingTableHelpers {
  static Widget buildStatusCell(String? status) {
    return BaseTableCellFactory.status(
      status: status ?? '-',
      color: _getStatusColor(status),
    );
  }

  static Widget buildStatusBookCell(String status) {
    return BaseTableCellFactory.status(
      status: status,
      color: _getStatusBookColor(status),
    );
  }

  static Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'PICKED':
        return Colors.green;
      case 'YET':
        return Colors.orange;
      default:
        return AppColor.GRAY_DARK;
    }
  }

  static Color _getStatusBookColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.yellow.shade700;
      case 'ACCEPTED':
        return Colors.blue;
      case 'COMPLETE':
        return Colors.green;
      case 'CANCELED':
        return Colors.red;
      default:
        return AppColor.GRAY_DARK;
    }
  }
}


