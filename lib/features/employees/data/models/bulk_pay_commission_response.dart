import 'package:the_dunes/features/employees/data/models/commission_model.dart';
import 'package:the_dunes/features/employees/domain/entities/commission_entity.dart';

class BulkPayCommissionResponse {
  final List<CommissionEntity> paid;
  final List<BulkPayFailure> failed;
  final int totalRequested;
  final int totalPaid;
  final int totalFailed;
  final double totalAmount;

  BulkPayCommissionResponse({
    required this.paid,
    required this.failed,
    required this.totalRequested,
    required this.totalPaid,
    required this.totalFailed,
    required this.totalAmount,
  });

  factory BulkPayCommissionResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final paidData = data['paid'] as List<dynamic>? ?? [];
    final failedData = data['failed'] as List<dynamic>? ?? [];

    return BulkPayCommissionResponse(
      paid: paidData
          .map((item) => CommissionModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      failed: failedData
          .map((item) => BulkPayFailure(
                commissionId: item['commissionId'] ?? 0,
                error: item['error'] ?? '',
              ))
          .toList(),
      totalRequested: data['totalRequested'] ?? 0,
      totalPaid: data['totalPaid'] ?? 0,
      totalFailed: data['totalFailed'] ?? 0,
      totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
    );
  }
}

class BulkPayFailure {
  final int commissionId;
  final String error;

  BulkPayFailure({
    required this.commissionId,
    required this.error,
  });
}

