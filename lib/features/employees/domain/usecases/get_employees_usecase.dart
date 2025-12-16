import 'package:the_dunes/core/data/models/paginated_response.dart';
import 'package:the_dunes/features/employees/domain/entities/employee_entity.dart';
import 'package:the_dunes/features/employees/domain/repositories/employee_repository.dart';

class GetEmployeesUseCase {
  final EmployeeRepository repository;

  GetEmployeesUseCase(this.repository);

  Future<PaginatedResponse<EmployeeEntity>> call({
    int page = 1,
    int pageSize = 20,
  }) {
    return repository.getEmployees(page: page, pageSize: pageSize);
  }
}



