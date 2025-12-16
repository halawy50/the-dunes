import 'package:the_dunes/features/employees/data/models/commission_model.dart';

class CommissionFactory {
  static CommissionModel fromJson(Map<String, dynamic> json) {
    return CommissionModel(
      id: json['id'] ?? 0,
      employeeId: json['employeeId'] ?? 0,
      employeeName: json['employeeName'] ?? '',
      receiptVoucherId: json['receiptVoucherId'],
      amount: (json['amount'] is num
          ? (json['amount'] as num).toDouble()
          : double.tryParse(json['amount'].toString()) ?? 0.0),
      status: json['status'] ?? 'PENDING',
      createdAt: json['createdAt'],
      paidAt: json['paidAt'],
      note: json['note'],
    );
  }
}



