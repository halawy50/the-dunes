class CommissionEntity {
  final int id;
  final int employeeId;
  final String employeeName;
  final int? receiptVoucherId;
  final double amount;
  final String status;
  final int? createdAt;
  final int? paidAt;
  final String? note;

  CommissionEntity({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    this.receiptVoucherId,
    required this.amount,
    required this.status,
    this.createdAt,
    this.paidAt,
    this.note,
  });
}


