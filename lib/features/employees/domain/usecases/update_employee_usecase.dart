import 'package:the_dunes/features/employees/domain/entities/employee_entity.dart';
import 'package:the_dunes/features/employees/domain/repositories/employee_repository.dart';

class UpdateEmployeeUseCase {
  final EmployeeRepository repository;

  UpdateEmployeeUseCase(this.repository);

  Future<EmployeeEntity> call(int id, Map<String, dynamic> data) {
    return repository.updateEmployee(id, data);
  }
}



