import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_cell_factory.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/employees/domain/entities/commission_entity.dart';

class EmployeeCommissionTableColumns {
  static List<BaseTableColumn<CommissionEntity>> buildColumns(
    void Function(int) onPayCommission,
  ) {
    return [
      BaseTableColumn<CommissionEntity>(
        headerKey: 'employees.voucher_id',
        width: 120,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.receiptVoucherId?.toString() ?? '-',
        ),
      ),
      BaseTableColumn<CommissionEntity>(
        headerKey: 'employees.amount',
        width: 150,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: '${item.amount.toStringAsFixed(2)} AED',
        ),
      ),
      BaseTableColumn<CommissionEntity>(
        headerKey: 'employees.status',
        width: 120,
        cellBuilder: (item, index) => BaseTableCellFactory.status(
          status: item.status == 'PAID'
              ? 'employees.paid'.tr()
              : item.status == 'PENDING'
                  ? 'employees.pending'.tr()
                  : 'employees.cancelled'.tr(),
          color: item.status == 'PAID'
              ? Colors.green
              : item.status == 'PENDING'
                  ? AppColor.YELLOW
                  : AppColor.GRAY_HULF,
        ),
      ),
      BaseTableColumn<CommissionEntity>(
        headerKey: 'employees.created_at',
        width: 150,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.createdAt != null
              ? DateFormat('yyyy/MM/dd').format(
                  DateTime.fromMillisecondsSinceEpoch(item.createdAt! * 1000),
                )
              : '-',
        ),
      ),
      BaseTableColumn<CommissionEntity>(
        headerKey: 'employees.paid_at',
        width: 150,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.paidAt != null
              ? DateFormat('yyyy/MM/dd').format(
                  DateTime.fromMillisecondsSinceEpoch(item.paidAt! * 1000),
                )
              : '-',
        ),
      ),
      BaseTableColumn<CommissionEntity>(
        headerKey: 'employees.actions',
        width: 150,
        cellBuilder: (item, index) {
          if (item.status == 'PAID') {
            return const SizedBox.shrink();
          }
          return ElevatedButton(
            onPressed: () => onPayCommission(item.id),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.YELLOW,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text('employees.pay'.tr()),
          );
        },
      ),
    ];
  }
}

