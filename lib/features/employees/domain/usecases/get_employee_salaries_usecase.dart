import 'package:the_dunes/features/employees/domain/entities/salary_entity.dart';
import 'package:the_dunes/features/employees/domain/repositories/employee_repository.dart';

class GetEmployeeSalariesUseCase {
  final EmployeeRepository repository;

  GetEmployeeSalariesUseCase(this.repository);

  Future<List<SalaryEntity>> call(
    int employeeId, {
    String? year,
    String? month,
  }) {
    return repository.getEmployeeSalaries(employeeId, year: year, month: month);
  }
}



