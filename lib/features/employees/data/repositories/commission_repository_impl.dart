import 'package:the_dunes/core/data/models/paginated_response.dart';
import 'package:the_dunes/features/employees/data/datasources/commission_remote_data_source.dart';
import 'package:the_dunes/features/employees/data/models/bulk_pay_commission_response.dart';
import 'package:the_dunes/features/employees/domain/entities/commission_entity.dart';
import 'package:the_dunes/features/employees/domain/repositories/commission_repository.dart';

class CommissionRepositoryImpl implements CommissionRepository {
  final CommissionRemoteDataSource dataSource;

  CommissionRepositoryImpl(this.dataSource);

  @override
  Future<PaginatedResponse<CommissionEntity>> getCommissions({
    int? employeeId,
    String? status,
    int page = 1,
    int pageSize = 20,
  }) async {
    final result = await dataSource.getCommissions(
      employeeId: employeeId,
      status: status,
      page: page,
      pageSize: pageSize,
    );
    return PaginatedResponse<CommissionEntity>(
      success: result.success,
      message: result.message,
      data: result.data,
      pagination: result.pagination,
    );
  }

  @override
  Future<CommissionEntity> getCommissionById(int id) async {
    return await dataSource.getCommissionById(id);
  }

  @override
  Future<CommissionEntity> createCommission(Map<String, dynamic> data) async {
    return await dataSource.createCommission(data);
  }

  @override
  Future<CommissionEntity> updateCommission(
    int id,
    Map<String, dynamic> data,
  ) async {
    return await dataSource.updateCommission(id, data);
  }

  @override
  Future<CommissionEntity> payCommission(int id, {String? note}) async {
    return await dataSource.payCommission(id, note: note);
  }

  @override
  Future<BulkPayCommissionResponse> bulkPayCommissions(
    List<int> commissionIds, {
    String? note,
  }) async {
    return await dataSource.bulkPayCommissions(commissionIds, note: note);
  }
}

