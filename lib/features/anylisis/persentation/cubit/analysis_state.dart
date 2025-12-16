part of 'analysis_cubit.dart';

abstract class AnalysisState extends Equatable {
  const AnalysisState();

  @override
  List<Object?> get props => [];
}

class AnalysisInitial extends AnalysisState {}

class AnalysisLoading extends AnalysisState {}

class AnalysisLoaded extends AnalysisState {
  final DashboardSummaryEntity dashboardSummary;
  final BookingsByAgencyEntity bookingsByAgency;
  final EmployeesWithVouchersEntity employeesWithVouchers;

  const AnalysisLoaded({
    required this.dashboardSummary,
    required this.bookingsByAgency,
    required this.employeesWithVouchers,
  });

  @override
  List<Object?> get props => [
        dashboardSummary,
        bookingsByAgency,
        employeesWithVouchers,
      ];
}

class AnalysisSuccess extends AnalysisState {
  final String message;

  const AnalysisSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AnalysisError extends AnalysisState {
  final String message;

  const AnalysisError(this.message);

  @override
  List<Object?> get props => [message];
}
