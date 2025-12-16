import 'package:the_dunes/features/anylisis/data/datasources/statistics_remote_data_source.dart';
import 'package:the_dunes/features/anylisis/domain/entities/bookings_by_agency_entity.dart';
import 'package:the_dunes/features/anylisis/domain/entities/dashboard_summary_entity.dart';
import 'package:the_dunes/features/anylisis/domain/entities/employee_with_vouchers_entity.dart';
import 'package:the_dunes/features/anylisis/domain/entities/statistics_entity.dart';
import 'package:the_dunes/features/anylisis/domain/repositories/statistics_repository.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final StatisticsRemoteDataSource remoteDataSource;

  StatisticsRepositoryImpl(this.remoteDataSource);

  @override
  Future<StatisticsEntity> getStatistics({
    int? startDate,
    int? endDate,
  }) async {
    return await remoteDataSource.getStatistics(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<DashboardSummaryEntity> getDashboardSummary({
    int? startDate,
    int? endDate,
  }) async {
    return await remoteDataSource.getDashboardSummary(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<BookingsByAgencyEntity> getBookingsByAgency({
    int? startDate,
    int? endDate,
  }) async {
    return await remoteDataSource.getBookingsByAgency(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<EmployeesWithVouchersEntity> getEmployeesWithVouchers({
    int? startDate,
    int? endDate,
  }) async {
    return await remoteDataSource.getEmployeesWithVouchers(
      startDate: startDate,
      endDate: endDate,
    );
  }
}

