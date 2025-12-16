import 'package:equatable/equatable.dart';

class DashboardSummaryEntity extends Equatable {
  final double totalEarnings;
  final double totalIncome;
  final double totalOutcome;
  final double netProfit;

  const DashboardSummaryEntity({
    required this.totalEarnings,
    required this.totalIncome,
    required this.totalOutcome,
    required this.netProfit,
  });

  @override
  List<Object?> get props => [totalEarnings, totalIncome, totalOutcome, netProfit];
}

