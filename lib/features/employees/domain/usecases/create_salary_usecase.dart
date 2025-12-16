import 'package:the_dunes/features/employees/domain/entities/salary_entity.dart';
import 'package:the_dunes/features/employees/domain/repositories/salary_repository.dart';

class CreateSalaryUseCase {
  final SalaryRepository repository;

  CreateSalaryUseCase(this.repository);

  Future<SalaryEntity> call(Map<String, dynamic> data) {
    return repository.createSalary(data);
  }
}

