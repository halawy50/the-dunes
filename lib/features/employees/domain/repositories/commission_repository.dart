import 'package:the_dunes/core/data/models/paginated_response.dart';
import 'package:the_dunes/features/employees/domain/entities/commission_entity.dart';
import 'package:the_dunes/features/employees/data/models/bulk_pay_commission_response.dart';

abstract class CommissionRepository {
  Future<PaginatedResponse<CommissionEntity>> getCommissions({
    int? employeeId,
    String? status,
    int page = 1,
    int pageSize = 20,
  });

  Future<CommissionEntity> getCommissionById(int id);

  Future<CommissionEntity> createCommission(Map<String, dynamic> data);

  Future<CommissionEntity> updateCommission(int id, Map<String, dynamic> data);

  Future<CommissionEntity> payCommission(int id, {String? note});

  Future<BulkPayCommissionResponse> bulkPayCommissions(
    List<int> commissionIds, {
    String? note,
  });
}


