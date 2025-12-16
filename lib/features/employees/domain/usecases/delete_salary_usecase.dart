import 'package:the_dunes/features/employees/domain/repositories/salary_repository.dart';

class DeleteSalaryUseCase {
  final SalaryRepository repository;

  DeleteSalaryUseCase(this.repository);

  Future<void> call(int id) {
    return repository.deleteSalary(id);
  }
}

