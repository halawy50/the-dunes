import 'package:the_dunes/features/employees/domain/entities/salary_entity.dart';
import 'package:the_dunes/features/employees/domain/repositories/salary_repository.dart';

class UpdateSalaryUseCase {
  final SalaryRepository repository;

  UpdateSalaryUseCase(this.repository);

  Future<SalaryEntity> call(int id, Map<String, dynamic> data) {
    return repository.updateSalary(id, data);
  }
}

