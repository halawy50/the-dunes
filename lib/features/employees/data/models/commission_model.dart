import 'package:the_dunes/features/employees/data/models/commission_factory.dart';
import 'package:the_dunes/features/employees/domain/entities/commission_entity.dart';

class CommissionModel extends CommissionEntity {
  CommissionModel({
    required super.id,
    required super.employeeId,
    required super.employeeName,
    super.receiptVoucherId,
    required super.amount,
    required super.status,
    super.createdAt,
    super.paidAt,
    super.note,
  });

  factory CommissionModel.fromJson(Map<String, dynamic> json) {
    return CommissionFactory.fromJson(json);
  }
}



