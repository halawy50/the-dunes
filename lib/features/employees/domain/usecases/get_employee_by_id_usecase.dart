import 'package:the_dunes/features/employees/domain/entities/employee_entity.dart';
import 'package:the_dunes/features/employees/domain/repositories/employee_repository.dart';

class GetEmployeeByIdUseCase {
  final EmployeeRepository repository;

  GetEmployeeByIdUseCase(this.repository);

  Future<EmployeeEntity> call(int id) {
    return repository.getEmployeeById(id);
  }
}



