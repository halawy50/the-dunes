import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/employees/domain/entities/employee_entity.dart';

class EmployeeTableHelpers {
  static Map<String, dynamic> getPaidSalaryStatus(EmployeeEntity item) {
    if (!item.isSalary) {
      return {
        'text': '-',
        'color': AppColor.GRAY_HULF,
      };
    }

    if (item.lastMonthSalaryStatus == null) {
      return {
        'text': 'employees.pending'.tr(),
        'color': AppColor.YELLOW,
      };
    }

    Color statusColor;
    String statusText;

    switch (item.lastMonthSalaryStatus) {
      case 'PAID':
        statusColor = Colors.green;
        statusText = item.lastMonthSalaryStatusText ?? 'employees.paid'.tr();
        break;
      case 'HAS_UNPAID_MONTHS':
        statusColor = Colors.red;
        statusText = item.lastMonthSalaryStatusText ?? 'employees.has_unpaid_months'.tr();
        break;
      case 'UNPAID':
      default:
        statusColor = AppColor.YELLOW;
        statusText = item.lastMonthSalaryStatusText ?? 'employees.pending'.tr();
        break;
    }

    return {
      'text': statusText,
      'color': statusColor,
    };
  }

  static String getPaidCommissionStatus(EmployeeEntity item) {
    if (!item.isCommission) {
      return '-';
    }
    if (item.profit != null) {
      return '${item.profit!.toStringAsFixed(2)} AED';
    }
    return '-';
  }

  static String getPermissionsText(EmployeeEntity item) {
    if (item.permissions == null || item.permissions!.isEmpty) {
      return 'common.all'.tr();
    }
    
    // Get all permission keys that are true
    final enabledPermissions = item.permissions!.entries
        .where((e) => e.value == true)
        .map((e) => e.key)
        .toList();
    
    // If no permissions enabled, return dash
    if (enabledPermissions.isEmpty) {
      return '-';
    }
    
    // List of all possible permissions (based on API response)
    final allPossiblePermissions = [
      'overviewScreen', 'analysisScreen', 'bookingScreen', 'showAllBooking',
      'showMyBookAdded', 'addNewBook', 'editBook', 'deleteBook',
      'receiptVoucherScreen', 'showAllReceiptVoucher', 'showReceiptVoucherAdded',
      'addNewReceiptVoucherMe', 'addNewReceiptVoucherOtherEmployee',
      'editReceiptVoucher', 'deleteReceiptVoucher', 'pickupTimeScreen',
      'showAllPickup', 'editAnyPickup', 'serviceScreen', 'showAllService',
      'addNewService', 'editService', 'deleteService', 'hotelScreen',
      'showAllHotels', 'addNewHotels', 'editHotels', 'deleteHotels',
      'campScreen', 'showAllCampBookings', 'changeStateBooking',
      'operationsScreen', 'showAllOperations', 'addNewOperation',
      'editOperation', 'deleteOperation', 'historyScreen', 'showAllHistory',
      'settingScreen',
    ];
    
    // Check if all possible permissions are enabled
    // We check if the enabled permissions count matches all possible permissions
    // and if all keys in allPossiblePermissions exist and are true
    final allEnabled = allPossiblePermissions.every(
      (key) => item.permissions![key] == true,
    );
    
    if (allEnabled) {
      return 'common.all'.tr();
    }
    
    // Build text with permissions (max 2 lines, approximately 50 chars per line)
    final text = enabledPermissions.join(', ');
    
    // If text is too long, truncate to fit 2 lines
    if (text.length > 100) {
      // Try to fit in 2 lines (approximately 50 chars per line)
      final firstLineEnd = text.indexOf(',', 45);
      if (firstLineEnd != -1 && firstLineEnd < 50) {
        final firstLine = text.substring(0, firstLineEnd);
        final remaining = text.substring(firstLineEnd + 2); // Skip ', '
        
        if (remaining.length > 50) {
          // Second line would also be too long, truncate
          final secondLineEnd = remaining.indexOf(',', 45);
          if (secondLineEnd != -1) {
            return '${firstLine.trim()}\n${remaining.substring(0, secondLineEnd).trim()}...';
          } else {
            return '${firstLine.trim()}\n${remaining.substring(0, 47).trim()}...';
          }
        } else {
          return '${firstLine.trim()}\n${remaining.trim()}';
        }
      } else {
        // No comma found in first 50 chars, just truncate
        return '${text.substring(0, 47).trim()}...';
      }
    }
    
    return text;
  }
}


