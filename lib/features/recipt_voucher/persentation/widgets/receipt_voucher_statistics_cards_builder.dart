import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_statistics_model.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/widgets/receipt_voucher_statistics_card_widget.dart';

class ReceiptVoucherStatisticsCardsBuilder {
  static List<Widget> buildProfitCards(
    ReceiptVoucherStatisticsModel statistics,
    NumberFormat priceFormat,
  ) {
    return [
      ReceiptVoucherStatisticsCardWidget(
        icon: Icons.attach_money,
        label: 'receipt_voucher.profit'.tr(),
        value: '${priceFormat.format(statistics.profit)} AED',
        color: Colors.green,
        isBold: true,
      ),
      ReceiptVoucherStatisticsCardWidget(
        icon: Icons.pending_actions,
        label: 'receipt_voucher.pending_profit'.tr(),
        value: '${priceFormat.format(statistics.pendingProfit)} AED',
        color: Colors.orange,
      ),
      ReceiptVoucherStatisticsCardWidget(
        icon: Icons.payments,
        label: 'receipt_voucher.paid_commissions'.tr(),
        value: '${priceFormat.format(statistics.paidCommissions)} AED',
        color: Colors.blue,
      ),
    ];
  }

  static List<Widget> buildTotalPriceCards(
    ReceiptVoucherStatisticsModel statistics,
    NumberFormat priceFormat,
  ) {
    final cards = <Widget>[];

    if (statistics.totalPriceCompleted != null) {
      cards.add(
        ReceiptVoucherStatisticsCardWidget(
          icon: Icons.check_circle_outline,
          label: 'receipt_voucher.total_price_completed'.tr(),
          value: '${priceFormat.format(statistics.totalPriceCompleted!)} AED',
          color: Colors.green,
        ),
      );
    }
    if (statistics.totalPricePending != null) {
      cards.add(
        ReceiptVoucherStatisticsCardWidget(
          icon: Icons.pending_outlined,
          label: 'receipt_voucher.total_price_pending'.tr(),
          value: '${priceFormat.format(statistics.totalPricePending!)} AED',
          color: Colors.orange,
        ),
      );
    }
    if (statistics.totalPriceCancelled != null) {
      cards.add(
        ReceiptVoucherStatisticsCardWidget(
          icon: Icons.cancel_outlined,
          label: 'receipt_voucher.total_price_cancelled'.tr(),
          value: '${priceFormat.format(statistics.totalPriceCancelled!)} AED',
          color: Colors.red,
        ),
      );
    }
    if (statistics.totalPrice != null) {
      cards.add(
        ReceiptVoucherStatisticsCardWidget(
          icon: Icons.account_balance_wallet,
          label: 'receipt_voucher.total_price'.tr(),
          value: '${priceFormat.format(statistics.totalPrice!)} AED',
          color: Colors.purple,
          isBold: true,
        ),
      );
    }

    return cards;
  }
}

