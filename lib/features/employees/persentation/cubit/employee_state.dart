part of 'employee_cubit.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object?> get props => [];
}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<EmployeeEntity> employees;
  final int currentPage;
  final int totalPages;
  final int totalItems;

  const EmployeeLoaded({
    required this.employees,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
  });

  @override
  List<Object?> get props => [employees, currentPage, totalPages, totalItems];
}

class EmployeeDetailLoaded extends EmployeeState {
  final EmployeeEntity employee;
  final List<CommissionEntity> commissions;
  final List<SalaryEntity> salaries;
  final double? totalPendingCommissions;

  const EmployeeDetailLoaded({
    required this.employee,
    required this.commissions,
    required this.salaries,
    this.totalPendingCommissions,
  });

  @override
  List<Object?> get props => [
        employee,
        commissions,
        salaries,
        totalPendingCommissions,
      ];
}

class EmployeeSuccess extends EmployeeState {
  final String message;
  const EmployeeSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class EmployeeError extends EmployeeState {
  final String message;
  const EmployeeError(this.message);

  @override
  List<Object?> get props => [message];
}
