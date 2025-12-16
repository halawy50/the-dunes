import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_dunes/core/data/models/paginated_response.dart';
import 'package:the_dunes/features/employees/domain/entities/commission_entity.dart';
import 'package:the_dunes/features/employees/domain/entities/employee_entity.dart';
import 'package:the_dunes/features/employees/domain/entities/salary_entity.dart';
import 'package:the_dunes/features/employees/domain/repositories/employee_repository.dart';
import 'package:the_dunes/features/employees/domain/repositories/commission_repository.dart';
import 'package:the_dunes/features/employees/domain/repositories/salary_repository.dart';

part 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final EmployeeRepository employeeRepository;
  final CommissionRepository commissionRepository;
  final SalaryRepository salaryRepository;

  EmployeeCubit({
    required this.employeeRepository,
    required this.commissionRepository,
    required this.salaryRepository,
  }) : super(EmployeeInitial());

  int get currentPage {
    final state = this.state;
    if (state is EmployeeLoaded) {
      return state.currentPage;
    }
    return 1;
  }

  int get totalPages {
    final state = this.state;
    if (state is EmployeeLoaded) {
      return state.totalPages;
    }
    return 1;
  }

  Future<void> loadEmployees({int page = 1, int pageSize = 20, bool append = false}) async {
    if (!append) {
      emit(EmployeeLoading());
    }
    try {
      final response = await employeeRepository.getEmployees(
        page: page,
        pageSize: pageSize,
      );
      final currentState = state;
      if (append && currentState is EmployeeLoaded) {
        emit(EmployeeLoaded(
          employees: [...currentState.employees, ...response.data],
          currentPage: response.pagination.currentPage,
          totalPages: response.pagination.totalPages,
          totalItems: response.pagination.totalItems,
        ));
      } else {
        emit(EmployeeLoaded(
          employees: response.data,
          currentPage: response.pagination.currentPage,
          totalPages: response.pagination.totalPages,
          totalItems: response.pagination.totalItems,
        ));
      }
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is EmployeeLoaded) {
      if (currentState.currentPage < currentState.totalPages) {
        await loadEmployees(
          page: currentState.currentPage + 1,
          append: true,
        );
      }
    }
  }

  Future<void> loadEmployeeDetail(int employeeId) async {
    emit(EmployeeLoading());
    try {
      final employee = await employeeRepository.getEmployeeById(employeeId);
      final commissions = await employeeRepository.getEmployeeCommissions(
        employeeId,
      );
      final salaries = await employeeRepository.getEmployeeSalaries(employeeId);
      final pendingCommissions =
          await employeeRepository.getEmployeePendingCommissions(employeeId);
      emit(EmployeeDetailLoaded(
        employee: employee,
        commissions: commissions,
        salaries: salaries,
        totalPendingCommissions:
            (pendingCommissions['totalPending'] as num?)?.toDouble(),
      ));
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  Future<void> createEmployee(Map<String, dynamic> data) async {
    emit(EmployeeLoading());
    try {
      await employeeRepository.createEmployee(data);
      emit(EmployeeSuccess('employees.create_success'.tr()));
      await loadEmployees();
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  Future<void> updateEmployee(int id, Map<String, dynamic> data) async {
    emit(EmployeeLoading());
    try {
      await employeeRepository.updateEmployee(id, data);
      emit(EmployeeSuccess('employees.update_success'.tr()));
      await loadEmployeeDetail(id);
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  Future<void> deleteEmployee(int id) async {
    emit(EmployeeLoading());
    try {
      await employeeRepository.deleteEmployee(id);
      emit(EmployeeSuccess('employees.delete_success'.tr()));
      await loadEmployees();
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  Future<void> refreshEmployees() async {
    await loadEmployees(page: currentPage);
  }

  Future<void> goToPage(int page) async {
    if (page < 1 || (totalPages > 0 && page > totalPages)) {
      return;
    }
    await loadEmployees(page: page);
  }

  Future<void> goToNextPage() async {
    if (currentPage < totalPages) {
      await goToPage(currentPage + 1);
    }
  }

  Future<void> goToPreviousPage() async {
    if (currentPage > 1) {
      await goToPage(currentPage - 1);
    }
  }
}
