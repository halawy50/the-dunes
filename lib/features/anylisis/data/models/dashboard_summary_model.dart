import 'package:the_dunes/features/anylisis/domain/entities/dashboard_summary_entity.dart';

class DashboardSummaryModel extends DashboardSummaryEntity {
  const DashboardSummaryModel({
    required super.totalEarnings,
    required super.totalIncome,
    required super.totalOutcome,
    required super.netProfit,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      totalEarnings: (json['totalEarnings'] as num? ?? 0).toDouble(),
      totalIncome: (json['totalIncome'] as num? ?? 0).toDouble(),
      totalOutcome: (json['totalOutcome'] as num? ?? 0).toDouble(),
      netProfit: (json['netProfit'] as num? ?? 0).toDouble(),
    );
  }
}

