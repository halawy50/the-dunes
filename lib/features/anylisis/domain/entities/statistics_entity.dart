import 'package:equatable/equatable.dart';

class BookingsStatisticsEntity extends Equatable {
  final int total;
  final int pending;
  final int accepted;
  final int completed;
  final int cancelled;

  const BookingsStatisticsEntity({
    required this.total,
    required this.pending,
    required this.accepted,
    required this.completed,
    required this.cancelled,
  });

  @override
  List<Object?> get props => [total, pending, accepted, completed, cancelled];
}

class VouchersStatisticsEntity extends Equatable {
  final int total;
  final int pending;
  final int accepted;
  final int completed;
  final int cancelled;

  const VouchersStatisticsEntity({
    required this.total,
    required this.pending,
    required this.accepted,
    required this.completed,
    required this.cancelled,
  });

  @override
  List<Object?> get props => [total, pending, accepted, completed, cancelled];
}

class OperationsStatisticsEntity extends Equatable {
  final double totalIncome;
  final double totalOutcome;
  final double profit;
  final int totalOperations;

  const OperationsStatisticsEntity({
    required this.totalIncome,
    required this.totalOutcome,
    required this.profit,
    required this.totalOperations,
  });

  @override
  List<Object?> get props => [totalIncome, totalOutcome, profit, totalOperations];
}

class EmployeesStatisticsEntity extends Equatable {
  final int total;
  final int active;
  final int inactive;
  final int suspended;
  final double totalPendingCommissions;

  const EmployeesStatisticsEntity({
    required this.total,
    required this.active,
    required this.inactive,
    required this.suspended,
    required this.totalPendingCommissions,
  });

  @override
  List<Object?> get props => [total, active, inactive, suspended, totalPendingCommissions];
}

class StatisticsEntity extends Equatable {
  final BookingsStatisticsEntity bookings;
  final VouchersStatisticsEntity vouchers;
  final OperationsStatisticsEntity operations;
  final EmployeesStatisticsEntity employees;
  final double totalRevenue;
  final double totalProfit;

  const StatisticsEntity({
    required this.bookings,
    required this.vouchers,
    required this.operations,
    required this.employees,
    required this.totalRevenue,
    required this.totalProfit,
  });

  @override
  List<Object?> get props => [
        bookings,
        vouchers,
        operations,
        employees,
        totalRevenue,
        totalProfit,
      ];
}

