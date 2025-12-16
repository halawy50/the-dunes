import 'package:flutter/material.dart';
import 'package:the_dunes/core/widgets/base_table/receipt_voucher/receipt_voucher_table_helpers.dart';
import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_model.dart';

class ReceiptVoucherProfitCell {
  static Widget build(ReceiptVoucherModel item) {
    final hasProfit = item.commissionEmployee != null && item.commissionEmployee! > 0;
    final currency = ReceiptVoucherTableHelpers.getCurrencyName(item.currencyId);
    final profitText = hasProfit
        ? '${item.commissionEmployee!.toStringAsFixed(2)} $currency'
        : '-';
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: hasProfit
          ? BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.green.withOpacity(0.3), width: 1),
            )
          : null,
      child: Text(
        profitText,
        style: hasProfit
            ? const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              )
            : const TextStyle(fontSize: 12, color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }
}

