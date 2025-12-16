import 'package:the_dunes/core/data/models/paginated_response.dart';
import 'package:the_dunes/features/employees/data/datasources/salary_remote_data_source.dart';
import 'package:the_dunes/features/employees/domain/entities/salary_entity.dart';
import 'package:the_dunes/features/employees/domain/repositories/salary_repository.dart';

class SalaryRepositoryImpl implements SalaryRepository {
  final SalaryRemoteDataSource dataSource;

  SalaryRepositoryImpl(this.dataSource);

  @override
  Future<PaginatedResponse<SalaryEntity>> getSalaries({
    int? employeeId,
    String? status,
    String? year,
    String? month,
    int page = 1,
    int pageSize = 20,
  }) async {
    final result = await dataSource.getSalaries(
      employeeId: employeeId,
      status: status,
      year: year,
      month: month,
      page: page,
      pageSize: pageSize,
    );
    return PaginatedResponse<SalaryEntity>(
      success: result.success,
      message: result.message,
      data: result.data,
      pagination: result.pagination,
    );
  }

  @override
  Future<SalaryEntity> getSalaryById(int id) async {
    return await dataSource.getSalaryById(id);
  }

  @override
  Future<SalaryEntity> createSalary(Map<String, dynamic> data) async {
    return await dataSource.createSalary(data);
  }

  @override
  Future<SalaryEntity> updateSalary(
    int id,
    Map<String, dynamic> data,
  ) async {
    return await dataSource.updateSalary(id, data);
  }

  @override
  Future<SalaryEntity> paySalary(int id) async {
    return await dataSource.paySalary(id);
  }

  @override
  Future<void> deleteSalary(int id) async {
    return await dataSource.deleteSalary(id);
  }
}

