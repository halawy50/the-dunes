import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/anylisis/domain/entities/dashboard_summary_entity.dart';
import 'package:the_dunes/features/anylisis/persentation/widgets/analysis_card.dart';

class AnalysisDashboardCards extends StatelessWidget {
  final DashboardSummaryEntity summary;
  final NumberFormat priceFormat;

  const AnalysisDashboardCards({
    super.key,
    required this.summary,
    required this.priceFormat,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1200
            ? 3
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

        return Container(
          color: AppColor.WHITE,
          child: GridView.count(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              AnalysisCard(
                title: 'analysis.total_income'.tr(),
                value: '${priceFormat.format(summary.totalIncome)} AED',
                icon: Icons.trending_up,
                color: Colors.green,
              ),
              AnalysisCard(
                title: 'analysis.total_outcome'.tr(),
                value: '${priceFormat.format(summary.totalOutcome)} AED',
                icon: Icons.trending_down,
                color: Colors.red,
              ),
              AnalysisCard(
                title: 'analysis.net_profit'.tr(),
                value: '${priceFormat.format(summary.netProfit)} AED',
                icon: Icons.account_balance_wallet,
                color: Colors.green,
              ),
            ],
          ),
        );
      },
    );
  }
}

