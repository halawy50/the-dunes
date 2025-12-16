import 'package:the_dunes/core/data/models/paginated_response.dart';
import 'package:the_dunes/features/employees/domain/entities/salary_entity.dart';

abstract class SalaryRepository {
  Future<PaginatedResponse<SalaryEntity>> getSalaries({
    int? employeeId,
    String? status,
    String? year,
    String? month,
    int page = 1,
    int pageSize = 20,
  });

  Future<SalaryEntity> getSalaryById(int id);

  Future<SalaryEntity> createSalary(Map<String, dynamic> data);

  Future<SalaryEntity> updateSalary(int id, Map<String, dynamic> data);

  Future<SalaryEntity> paySalary(int id);

  Future<void> deleteSalary(int id);
}



