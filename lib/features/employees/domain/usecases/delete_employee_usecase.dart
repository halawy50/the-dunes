import 'package:the_dunes/features/employees/domain/repositories/employee_repository.dart';

class DeleteEmployeeUseCase {
  final EmployeeRepository repository;

  DeleteEmployeeUseCase(this.repository);

  Future<void> call(int id) {
    return repository.deleteEmployee(id);
  }
}



