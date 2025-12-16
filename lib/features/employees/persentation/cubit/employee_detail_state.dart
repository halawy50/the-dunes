part of 'employee_detail_cubit.dart';

abstract class EmployeeDetailState extends Equatable {
  const EmployeeDetailState();

  @override
  List<Object?> get props => [];
}

class EmployeeDetailInitial extends EmployeeDetailState {}

class EmployeeDetailLoading extends EmployeeDetailState {}

class EmployeeDetailLoaded extends EmployeeDetailState {
  final EmployeeEntity employee;
  final List<CommissionEntity> commissions;
  final List<SalaryEntity> salaries;
  final double? totalPendingCommissions;
  final int? payingSalaryId;

  const EmployeeDetailLoaded({
    required this.employee,
    required this.commissions,
    required this.salaries,
    this.totalPendingCommissions,
    this.payingSalaryId,
  });

  @override
  List<Object?> get props => [
        employee,
        commissions,
        salaries,
        totalPendingCommissions,
        payingSalaryId,
      ];
}

class EmployeeDetailError extends EmployeeDetailState {
  final String message;
  const EmployeeDetailError(this.message);

  @override
  List<Object?> get props => [message];
}



