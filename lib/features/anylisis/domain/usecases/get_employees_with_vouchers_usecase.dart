import 'package:the_dunes/features/anylisis/domain/entities/employee_with_vouchers_entity.dart';
import 'package:the_dunes/features/anylisis/domain/repositories/statistics_repository.dart';

class GetEmployeesWithVouchersUseCase {
  final StatisticsRepository repository;

  GetEmployeesWithVouchersUseCase(this.repository);

  Future<EmployeesWithVouchersEntity> call({
    int? startDate,
    int? endDate,
  }) async {
    return await repository.getEmployeesWithVouchers(
      startDate: startDate,
      endDate: endDate,
    );
  }
}

