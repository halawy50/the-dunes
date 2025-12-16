import 'package:the_dunes/features/employees/domain/entities/employee_entity.dart';
import 'package:the_dunes/features/employees/domain/repositories/employee_repository.dart';

class CreateEmployeeUseCase {
  final EmployeeRepository repository;

  CreateEmployeeUseCase(this.repository);

  Future<EmployeeEntity> call(Map<String, dynamic> data) {
    return repository.createEmployee(data);
  }
}



