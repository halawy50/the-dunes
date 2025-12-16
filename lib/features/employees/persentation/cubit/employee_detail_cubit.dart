import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_dunes/features/employees/data/models/bulk_pay_commission_response.dart';
import 'package:the_dunes/features/employees/domain/entities/commission_entity.dart';
import 'package:the_dunes/features/employees/domain/entities/employee_entity.dart';
import 'package:the_dunes/features/employees/domain/entities/salary_entity.dart';
import 'package:the_dunes/features/employees/domain/repositories/employee_repository.dart';
import 'package:the_dunes/features/employees/domain/repositories/commission_repository.dart';
import 'package:the_dunes/features/employees/domain/repositories/salary_repository.dart';

part 'employee_detail_state.dart';

class EmployeeDetailCubit extends Cubit<EmployeeDetailState> {
  final EmployeeRepository employeeRepository;
  final CommissionRepository commissionRepository;
  final SalaryRepository salaryRepository;

  EmployeeDetailCubit({
    required this.employeeRepository,
    required this.commissionRepository,
    required this.salaryRepository,
  }) : super(EmployeeDetailInitial());

  Future<void> loadEmployeeDetail(int employeeId) async {
    emit(EmployeeDetailLoading());
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
            (pendingCommissions['totalPending'] as num?)?.toDouble() ?? 0.0,
        payingSalaryId: null,
      ));
    } catch (e) {
      emit(EmployeeDetailError(e.toString()));
    }
  }

  Future<void> payCommission(int commissionId, {String? note}) async {
    final currentState = this.state;
    if (currentState is! EmployeeDetailLoaded) return;

    try {
      final updatedCommission = await commissionRepository.payCommission(
        commissionId,
        note: note,
      );

      final updatedCommissions = currentState.commissions.map((commission) {
        if (commission.id == commissionId) {
          return updatedCommission;
        }
        return commission;
      }).toList();

      final pendingCommissions = updatedCommissions
          .where((c) => c.status == 'PENDING')
          .fold<double>(0.0, (sum, c) => sum + c.amount);

      emit(EmployeeDetailLoaded(
        employee: currentState.employee,
        commissions: updatedCommissions,
        salaries: currentState.salaries,
        totalPendingCommissions: pendingCommissions,
        payingSalaryId: null,
      ));

      await loadEmployeeDetail(currentState.employee.id);
    } catch (e) {
      emit(EmployeeDetailError(e.toString()));
    }
  }

  Future<void> paySalary(int salaryId) async {
    final currentState = this.state;
    if (currentState is! EmployeeDetailLoaded) return;

    emit(EmployeeDetailLoaded(
      employee: currentState.employee,
      commissions: currentState.commissions,
      salaries: currentState.salaries,
      totalPendingCommissions: currentState.totalPendingCommissions,
      payingSalaryId: salaryId,
    ));

    try {
      final updatedSalary = await salaryRepository.paySalary(salaryId);
      final updatedSalaries = currentState.salaries.map((salary) {
        if (salary.id == salaryId) {
          return updatedSalary;
        }
        return salary;
      }).toList();

      emit(EmployeeDetailLoaded(
        employee: currentState.employee,
        commissions: currentState.commissions,
        salaries: updatedSalaries,
        totalPendingCommissions: currentState.totalPendingCommissions,
        payingSalaryId: null,
      ));
    } catch (e) {
      emit(EmployeeDetailLoaded(
        employee: currentState.employee,
        commissions: currentState.commissions,
        salaries: currentState.salaries,
        totalPendingCommissions: currentState.totalPendingCommissions,
        payingSalaryId: null,
      ));
      emit(EmployeeDetailError(e.toString()));
    }
  }

  Future<void> createSalary(Map<String, dynamic> data) async {
    final currentState = this.state;
    if (currentState is! EmployeeDetailLoaded) return;

    try {
      final newSalary = await salaryRepository.createSalary(data);
      final updatedSalaries = [newSalary, ...currentState.salaries];

      emit(EmployeeDetailLoaded(
        employee: currentState.employee,
        commissions: currentState.commissions,
        salaries: updatedSalaries,
        totalPendingCommissions: currentState.totalPendingCommissions,
        payingSalaryId: null,
      ));
    } catch (e) {
      emit(EmployeeDetailError(e.toString()));
    }
  }

  Future<void> updateSalary(int salaryId, Map<String, dynamic> data) async {
    final currentState = this.state;
    if (currentState is! EmployeeDetailLoaded) return;

    try {
      final updatedSalary = await salaryRepository.updateSalary(salaryId, data);
      final updatedSalaries = currentState.salaries.map((salary) {
        if (salary.id == salaryId) {
          return updatedSalary;
        }
        return salary;
      }).toList();

      emit(EmployeeDetailLoaded(
        employee: currentState.employee,
        commissions: currentState.commissions,
        salaries: updatedSalaries,
        totalPendingCommissions: currentState.totalPendingCommissions,
        payingSalaryId: null,
      ));
    } catch (e) {
      emit(EmployeeDetailError(e.toString()));
    }
  }

  Future<void> deleteSalary(int salaryId) async {
    final currentState = this.state;
    if (currentState is! EmployeeDetailLoaded) return;

    try {
      await salaryRepository.deleteSalary(salaryId);
      final updatedSalaries = currentState.salaries
          .where((salary) => salary.id != salaryId)
          .toList();

      emit(EmployeeDetailLoaded(
        employee: currentState.employee,
        commissions: currentState.commissions,
        salaries: updatedSalaries,
        totalPendingCommissions: currentState.totalPendingCommissions,
        payingSalaryId: null,
      ));
    } catch (e) {
      emit(EmployeeDetailError(e.toString()));
    }
  }

  Future<BulkPayCommissionResponse?> bulkPayCommissions(
    List<int> commissionIds, {
    String? note,
  }) async {
    final currentState = this.state;
    if (currentState is! EmployeeDetailLoaded) return null;

    final response = await commissionRepository.bulkPayCommissions(
      commissionIds,
      note: note,
    );

    final paidIds = response.paid.map((c) => c.id).toSet();
    final updatedCommissions = currentState.commissions.map((commission) {
      if (paidIds.contains(commission.id)) {
        return response.paid.firstWhere((c) => c.id == commission.id);
      }
      return commission;
    }).toList();

    final pendingCommissions = updatedCommissions
        .where((c) => c.status == 'PENDING')
        .fold<double>(0.0, (sum, c) => sum + c.amount);

      emit(EmployeeDetailLoaded(
        employee: currentState.employee,
        commissions: updatedCommissions,
        salaries: currentState.salaries,
        totalPendingCommissions: pendingCommissions,
        payingSalaryId: null,
      ));

      await loadEmployeeDetail(currentState.employee.id);
    return response;
  }

  Future<Map<String, dynamic>?> resetPassword({
    int? employeeId,
    String? email,
    required String newPassword,
  }) async {
    try {
      final result = await employeeRepository.resetPassword(
        employeeId: employeeId,
        email: email,
        newPassword: newPassword,
      );
      return result;
    } catch (e) {
      emit(EmployeeDetailError(e.toString()));
      return null;
    }
  }
}

