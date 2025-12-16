import 'package:the_dunes/features/employees/domain/repositories/employee_repository.dart';

class GetEmployeePendingCommissionsUseCase {
  final EmployeeRepository repository;

  GetEmployeePendingCommissionsUseCase(this.repository);

  Future<Map<String, dynamic>> call(int employeeId) {
    return repository.getEmployeePendingCommissions(employeeId);
  }
}



