import 'package:the_dunes/features/employees/domain/entities/salary_entity.dart';
import 'package:the_dunes/features/employees/domain/repositories/salary_repository.dart';

class PaySalaryUseCase {
  final SalaryRepository repository;

  PaySalaryUseCase(this.repository);

  Future<SalaryEntity> call(int id) {
    return repository.paySalary(id);
  }
}



