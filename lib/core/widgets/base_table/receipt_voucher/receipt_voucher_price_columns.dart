import 'package:flutter/material.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_cell_factory.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_model.dart';
import 'package:the_dunes/core/widgets/base_table/receipt_voucher/receipt_voucher_table_helpers.dart';

class ReceiptVoucherPriceColumns {
  static List<BaseTableColumn<ReceiptVoucherModel>> build() {
    return [
      BaseTableColumn<ReceiptVoucherModel>(
        headerKey: 'receipt_voucher.p_before_discount',
        width: 110,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: '${item.priceBeforePercentage.toStringAsFixed(2)} ${ReceiptVoucherTableHelpers.getCurrencyName(item.currencyId)}',
        ),
      ),
      BaseTableColumn<ReceiptVoucherModel>(
        headerKey: 'receipt_voucher.discount',
        width: 80,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.discountPercentage != null
              ? '${item.discountPercentage}%'
              : '0%',
        ),
      ),
      BaseTableColumn<ReceiptVoucherModel>(
        headerKey: 'receipt_voucher.t_revenue',
        width: 110,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: '${item.finalPriceAfterDeductingCommissionEmployee.toStringAsFixed(2)} ${ReceiptVoucherTableHelpers.getCurrencyName(item.currencyId)}',
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ),
      BaseTableColumn<ReceiptVoucherModel>(
        headerKey: 'receipt_voucher.currency',
        width: 80,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: ReceiptVoucherTableHelpers.getCurrencyName(item.currencyId),
        ),
      ),
    ];
  }
}

