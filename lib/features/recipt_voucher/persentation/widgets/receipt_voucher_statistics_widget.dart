import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_statistics_model.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/widgets/receipt_voucher_statistics_cards_section.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/widgets/receipt_voucher_statistics_item_widget.dart';

class ReceiptVoucherStatisticsWidget extends StatelessWidget {
  final ReceiptVoucherStatisticsModel? statistics;

  const ReceiptVoucherStatisticsWidget({
    super.key,
    this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('[ReceiptVoucherStatisticsWidget] Statistics: $statistics');
      if (statistics != null) {
        print('[ReceiptVoucherStatisticsWidget] Total: ${statistics!.total}, Completed: ${statistics!.completed}, Pending: ${statistics!.pending}, Accepted: ${statistics!.accepted}, Cancelled: ${statistics!.cancelled}');
      } else {
        print('[ReceiptVoucherStatisticsWidget] Statistics is NULL');
      }
    }
    
    if (statistics == null) {
      return const SizedBox.shrink();
    }

    final priceFormat = NumberFormat('#,##0.00');
    final stats = statistics!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 28,
            runSpacing: 16,
            alignment: WrapAlignment.start,
            children: [
              ReceiptVoucherStatisticsItemWidget(
                icon: Icons.receipt_long,
                label: 'receipt_voucher.total'.tr(),
                value: stats.total.toString(),
              ),
              ReceiptVoucherStatisticsItemWidget(
                icon: Icons.check_circle,
                label: 'receipt_voucher.completed'.tr(),
                value: stats.completed.toString(),
                color: Colors.green,
              ),
              ReceiptVoucherStatisticsItemWidget(
                icon: Icons.pending,
                label: 'receipt_voucher.pending'.tr(),
                value: stats.pending.toString(),
                color: Colors.orange,
              ),
              ReceiptVoucherStatisticsItemWidget(
                icon: Icons.verified,
                label: 'receipt_voucher.accepted'.tr(),
                value: stats.accepted.toString(),
                color: Colors.blue,
              ),
              ReceiptVoucherStatisticsItemWidget(
                icon: Icons.cancel,
                label: 'receipt_voucher.cancelled'.tr(),
                value: stats.cancelled.toString(),
                color: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ReceiptVoucherStatisticsCardsSection(
            statistics: stats,
            priceFormat: priceFormat,
          ),
        ],
      ),
    );
  }
}

