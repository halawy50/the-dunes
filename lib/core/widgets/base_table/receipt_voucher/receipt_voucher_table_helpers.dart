import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:the_dunes/core/widgets/base_table/receipt_voucher/receipt_voucher_status_dropdown_cell.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_model.dart';

class ReceiptVoucherTableHelpers {
  static Widget buildStatusDropdown(
    ReceiptVoucherModel voucher,
    void Function(ReceiptVoucherModel, Map<String, dynamic>) onVoucherEdit,
    bool isLoading, {
    bool canEdit = true,
  }) {
    final statuses = ['PENDING', 'ACCEPTED', 'COMPLETED', 'CANCELLED'];
    
    // If user doesn't have edit permission, show status as text only
    if (!canEdit) {
      return _buildStatusText(voucher.status);
    }
    
    return ReceiptVoucherStatusDropdownCell(
      key: ValueKey('status_${voucher.id}_${voucher.status}'),
      value: voucher.status,
      items: statuses,
      isLoading: isLoading,
      onChanged: (newStatus) {
        if (newStatus != null && newStatus != voucher.status && !isLoading) {
          // Ensure we use the newStatus value, not the old voucher.status
          final statusUpdate = {'status': newStatus};
          // Debug: Print the values to verify
          if (kDebugMode) {
            print('[ReceiptVoucherTableHelpers] Status change for voucher ${voucher.id}');
            print('[ReceiptVoucherTableHelpers] Old status: ${voucher.status}');
            print('[ReceiptVoucherTableHelpers] New status: $newStatus');
            print('[ReceiptVoucherTableHelpers] Status update map: $statusUpdate');
          }
          onVoucherEdit(voucher, statusUpdate);
        }
      },
      getColor: _getStatusColor,
    );
  }
  
  static Widget _buildStatusText(String? status) {
    final validStatus = status ?? 'PENDING';
    final bgColor = _getStatusColor(validStatus);
    final textColor = _getStatusTextColor(validStatus);
    
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        validStatus,
        style: TextStyle(
          fontSize: 13,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  
  static Color _getStatusTextColor(String status) {
    final statusUpper = status.toUpperCase();
    switch (statusUpper) {
      case 'PENDING':
        return Colors.orange.shade700;
      case 'COMPLETED':
        return Colors.green.shade700;
      case 'ACCEPTED':
        return Colors.blue.shade700;
      case 'CANCELLED':
        return Colors.red.shade700;
      default:
        return AppColor.BLACK;
    }
  }

  static Color _getStatusColor(String status) {
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

  static String getCurrencyName(int? currencyId) {
    switch (currencyId) {
      case 1:
        return 'AED';
      case 2:
        return 'USD';
      case 3:
        return 'EUR';
      default:
        return 'AED';
    }
  }
}

