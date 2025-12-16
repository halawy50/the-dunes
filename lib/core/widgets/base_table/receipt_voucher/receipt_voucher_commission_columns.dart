import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_cell_factory.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_status_cell.dart';
import 'package:the_dunes/core/widgets/base_table/receipt_voucher/receipt_voucher_table_helpers.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_model.dart';

class ReceiptVoucherCommissionColumns {
  static List<BaseTableColumn<ReceiptVoucherModel>> build() {
    return [
      BaseTableColumn<ReceiptVoucherModel>(
        headerKey: 'receipt_voucher.commission_status',
        width: 120,
        cellBuilder: (item, index) {
          if (item.commissionStatus == null) {
            return BaseTableCellFactory.text(text: '-');
          }
          final status = item.commissionStatus!;
          final color = status == 'PAID'
              ? Colors.green
              : status == 'PENDING'
                  ? AppColor.YELLOW
                  : AppColor.GRAY_HULF;
          final statusText = status == 'PAID'
              ? 'receipt_voucher.paid'.tr()
              : status == 'PENDING'
                  ? 'receipt_voucher.pending'.tr()
                  : status;
          return BaseTableStatusCell(
            status: statusText,
            color: color,
          );
        },
      ),
      BaseTableColumn<ReceiptVoucherModel>(
        headerKey: 'receipt_voucher.commission_amount',
        width: 130,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.commissionAmount != null
              ? '${item.commissionAmount!.toStringAsFixed(2)} ${ReceiptVoucherTableHelpers.getCurrencyName(item.currencyId)}'
              : '-',
          style: item.commissionAmount != null && item.commissionAmount! > 0
              ? const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue)
              : null,
        ),
      ),
      BaseTableColumn<ReceiptVoucherModel>(
        headerKey: 'receipt_voucher.employee_total_paid_commission',
        width: 180,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.employeeTotalPaidCommission != null
              ? '${item.employeeTotalPaidCommission!.toStringAsFixed(2)} ${ReceiptVoucherTableHelpers.getCurrencyName(item.currencyId)}'
              : '-',
          style: item.employeeTotalPaidCommission != null && item.employeeTotalPaidCommission! > 0
              ? const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green)
              : null,
        ),
      ),
      BaseTableColumn<ReceiptVoucherModel>(
        headerKey: 'receipt_voucher.employee_total_pending_commission',
        width: 200,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.employeeTotalPendingCommission != null
              ? '${item.employeeTotalPendingCommission!.toStringAsFixed(2)} ${ReceiptVoucherTableHelpers.getCurrencyName(item.currencyId)}'
              : '-',
          style: item.employeeTotalPendingCommission != null && item.employeeTotalPendingCommission! > 0
              ? const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.orange)
              : null,
        ),
      ),
    ];
  }
}

