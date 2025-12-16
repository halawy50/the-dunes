import 'package:the_dunes/features/anylisis/domain/entities/statistics_entity.dart';

class BookingsStatisticsModel extends BookingsStatisticsEntity {
  const BookingsStatisticsModel({
    required super.total,
    required super.pending,
    required super.accepted,
    required super.completed,
    required super.cancelled,
  });

  factory BookingsStatisticsModel.fromJson(Map<String, dynamic> json) {
    return BookingsStatisticsModel(
      total: json['total'] as int,
      pending: json['pending'] as int,
      accepted: json['accepted'] as int,
      completed: json['completed'] as int,
      cancelled: json['cancelled'] as int,
    );
  }
}

class VouchersStatisticsModel extends VouchersStatisticsEntity {
  const VouchersStatisticsModel({
    required super.total,
    required super.pending,
    required super.accepted,
    required super.completed,
    required super.cancelled,
  });

  factory VouchersStatisticsModel.fromJson(Map<String, dynamic> json) {
    return VouchersStatisticsModel(
      total: json['total'] as int,
      pending: json['pending'] as int,
      accepted: json['accepted'] as int,
      completed: json['completed'] as int,
      cancelled: json['cancelled'] as int,
    );
  }
}

class OperationsStatisticsModel extends OperationsStatisticsEntity {
  const OperationsStatisticsModel({
    required super.totalIncome,
    required super.totalOutcome,
    required super.profit,
    required super.totalOperations,
  });

  factory OperationsStatisticsModel.fromJson(Map<String, dynamic> json) {
    return OperationsStatisticsModel(
      totalIncome: (json['totalIncome'] as num).toDouble(),
      totalOutcome: (json['totalOutcome'] as num).toDouble(),
      profit: (json['profit'] as num).toDouble(),
      totalOperations: json['totalOperations'] as int,
    );
  }
}

class EmployeesStatisticsModel extends EmployeesStatisticsEntity {
  const EmployeesStatisticsModel({
    required super.total,
    required super.active,
    required super.inactive,
    required super.suspended,
    required super.totalPendingCommissions,
  });

  factory EmployeesStatisticsModel.fromJson(Map<String, dynamic> json) {
    return EmployeesStatisticsModel(
      total: json['total'] as int,
      active: json['active'] as int,
      inactive: json['inactive'] as int,
      suspended: json['suspended'] as int,
      totalPendingCommissions: (json['totalPendingCommissions'] as num).toDouble(),
    );
  }
}

class StatisticsModel extends StatisticsEntity {
  const StatisticsModel({
    required super.bookings,
    required super.vouchers,
    required super.operations,
    required super.employees,
    required super.totalRevenue,
    required super.totalProfit,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      bookings: BookingsStatisticsModel.fromJson(json['bookings'] as Map<String, dynamic>),
      vouchers: VouchersStatisticsModel.fromJson(json['vouchers'] as Map<String, dynamic>),
      operations: OperationsStatisticsModel.fromJson(json['operations'] as Map<String, dynamic>),
      employees: EmployeesStatisticsModel.fromJson(json['employees'] as Map<String, dynamic>),
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      totalProfit: (json['totalProfit'] as num).toDouble(),
    );
  }
}

