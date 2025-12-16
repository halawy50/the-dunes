import 'package:the_dunes/features/anylisis/domain/entities/bookings_by_agency_entity.dart';
import 'package:the_dunes/features/anylisis/domain/entities/dashboard_summary_entity.dart';
import 'package:the_dunes/features/anylisis/domain/entities/employee_with_vouchers_entity.dart';
import 'package:the_dunes/features/anylisis/domain/entities/statistics_entity.dart';

abstract class StatisticsRepository {
  Future<StatisticsEntity> getStatistics({
    int? startDate,
    int? endDate,
  });
  Future<DashboardSummaryEntity> getDashboardSummary({
    int? startDate,
    int? endDate,
  });
  Future<BookingsByAgencyEntity> getBookingsByAgency({
    int? startDate,
    int? endDate,
  });
  Future<EmployeesWithVouchersEntity> getEmployeesWithVouchers({
    int? startDate,
    int? endDate,
  });
}

