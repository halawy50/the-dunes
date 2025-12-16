import 'package:the_dunes/features/employees/domain/entities/commission_entity.dart';
import 'package:the_dunes/features/employees/domain/repositories/employee_repository.dart';

class GetEmployeeCommissionsUseCase {
  final EmployeeRepository repository;

  GetEmployeeCommissionsUseCase(this.repository);

  Future<List<CommissionEntity>> call(int employeeId, {String? status}) {
    return repository.getEmployeeCommissions(employeeId, status: status);
  }
}



