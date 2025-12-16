import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_statistics_model.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/widgets/receipt_voucher_statistics_cards_builder.dart';

class ReceiptVoucherStatisticsCardsSection extends StatelessWidget {
  final ReceiptVoucherStatisticsModel statistics;
  final NumberFormat priceFormat;

  const ReceiptVoucherStatisticsCardsSection({
    super.key,
    required this.statistics,
    required this.priceFormat,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1200
            ? 4
            : constraints.maxWidth > 800
                ? 3
                : constraints.maxWidth > 600
                    ? 2
                    : 1;
        final childAspectRatio = constraints.maxWidth > 1200
            ? 2.5
            : constraints.maxWidth > 800
                ? 2.2
                : constraints.maxWidth > 600
                    ? 2.0
                    : 3.0;

        final profitCards = ReceiptVoucherStatisticsCardsBuilder.buildProfitCards(
          statistics,
          priceFormat,
        );
        final totalPriceCards = ReceiptVoucherStatisticsCardsBuilder.buildTotalPriceCards(
          statistics,
          priceFormat,
        );

        return Column(
          children: [
            GridView.count(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: childAspectRatio,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: profitCards,
            ),
            if (totalPriceCards.isNotEmpty) ...[
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: childAspectRatio,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: totalPriceCards,
              ),
            ],
          ],
        );
      },
    );
  }
}

