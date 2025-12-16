import 'package:the_dunes/features/employees/domain/repositories/employee_repository.dart';

class ResetPasswordUseCase {
  final EmployeeRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Map<String, dynamic>> call({
    int? employeeId,
    String? email,
    required String newPassword,
  }) {
    return repository.resetPassword(
      employeeId: employeeId,
      email: email,
      newPassword: newPassword,
    );
  }
}

