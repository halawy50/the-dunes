import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_dunes/features/anylisis/domain/entities/bookings_by_agency_entity.dart';
import 'package:the_dunes/features/anylisis/domain/entities/dashboard_summary_entity.dart';
import 'package:the_dunes/features/anylisis/domain/entities/employee_with_vouchers_entity.dart';
import 'package:the_dunes/features/anylisis/domain/usecases/get_bookings_by_agency_usecase.dart';
import 'package:the_dunes/features/anylisis/domain/usecases/get_dashboard_summary_usecase.dart';
import 'package:the_dunes/features/anylisis/domain/usecases/get_employees_with_vouchers_usecase.dart';

part 'analysis_state.dart';

class AnalysisCubit extends Cubit<AnalysisState> {
  final GetDashboardSummaryUseCase getDashboardSummaryUseCase;
  final GetBookingsByAgencyUseCase getBookingsByAgencyUseCase;
  final GetEmployeesWithVouchersUseCase getEmployeesWithVouchersUseCase;

  AnalysisCubit({
    required this.getDashboardSummaryUseCase,
    required this.getBookingsByAgencyUseCase,
    required this.getEmployeesWithVouchersUseCase,
  }) : super(AnalysisInitial());

  Future<void> loadAnalysisData({
    int? startDate,
    int? endDate,
  }) async {
    emit(AnalysisLoading());
    try {
      final dashboardSummary = await getDashboardSummaryUseCase(
        startDate: startDate,
        endDate: endDate,
      );
      final bookingsByAgency = await getBookingsByAgencyUseCase(
        startDate: startDate,
        endDate: endDate,
      );
      final employeesWithVouchers = await getEmployeesWithVouchersUseCase(
        startDate: startDate,
        endDate: endDate,
      );
      emit(AnalysisLoaded(
        dashboardSummary: dashboardSummary,
        bookingsByAgency: bookingsByAgency,
        employeesWithVouchers: employeesWithVouchers,
      ));
    } catch (e) {
      emit(AnalysisError(e.toString()));
    }
  }

  Future<void> refreshAnalysisData({
    int? startDate,
    int? endDate,
  }) async {
    await loadAnalysisData(startDate: startDate, endDate: endDate);
  }
}
