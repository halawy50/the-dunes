import 'package:flutter/material.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_model.dart';
import 'package:the_dunes/core/widgets/base_table/receipt_voucher/receipt_voucher_basic_columns.dart';
import 'package:the_dunes/core/widgets/base_table/receipt_voucher/receipt_voucher_price_columns.dart';
import 'package:the_dunes/core/widgets/base_table/receipt_voucher/receipt_voucher_commission_columns.dart';
import 'package:the_dunes/core/widgets/base_table/receipt_voucher/receipt_voucher_actions_cell.dart';

class ReceiptVoucherTableColumns {
  static List<BaseTableColumn<ReceiptVoucherModel>> buildColumns(
    void Function(ReceiptVoucherModel, Map<String, dynamic>) onVoucherEdit,
    bool Function(int, String) isUpdatingVoucher,
    void Function(ReceiptVoucherModel) onVoucherDelete,
    bool Function(int) isDeletingVoucher,
    Future<String> Function(int) onDownloadPdf, {
    int startNumber = 1,
    bool canEdit = true,
    bool canDelete = true,
  }) {
    final basicColumns = ReceiptVoucherBasicColumns.build(
      startNumber: startNumber,
      onVoucherEdit: onVoucherEdit,
      isUpdatingVoucher: isUpdatingVoucher,
      canEdit: canEdit,
    );
    
    final priceColumns = ReceiptVoucherPriceColumns.build();
    final commissionColumns = ReceiptVoucherCommissionColumns.build();
    
    return [
      ...basicColumns,
      ...priceColumns,
      ...commissionColumns,
      BaseTableColumn<ReceiptVoucherModel>(
        headerKey: 'common.actions',
        width: canEdit || canDelete ? 85 : 40,
        cellBuilder: (item, index) => Builder(
          builder: (context) => ReceiptVoucherActionsCell.build(
            voucher: item,
            onVoucherEdit: onVoucherEdit,
            onVoucherDelete: onVoucherDelete,
            isDeleting: isDeletingVoucher(item.id),
            onDownloadPdf: onDownloadPdf,
            context: context,
            canEdit: canEdit,
            canDelete: canDelete,
          ),
        ),
      ),
    ];
  }
}

