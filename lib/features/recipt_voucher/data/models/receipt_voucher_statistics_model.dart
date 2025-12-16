class ReceiptVoucherStatisticsModel {
  final int total;
  final int completed;
  final int pending;
  final int accepted;
  final int cancelled;
  final double profit;
  final double pendingProfit;
  final double paidCommissions;
  final double? totalPriceCompleted;
  final double? totalPricePending;
  final double? totalPriceAccepted;
  final double? totalPriceCancelled;
  final double? totalPrice;

  const ReceiptVoucherStatisticsModel({
    required this.total,
    required this.completed,
    required this.pending,
    required this.accepted,
    required this.cancelled,
    required this.profit,
    required this.pendingProfit,
    required this.paidCommissions,
    this.totalPriceCompleted,
    this.totalPricePending,
    this.totalPriceAccepted,
    this.totalPriceCancelled,
    this.totalPrice,
  });

  factory ReceiptVoucherStatisticsModel.fromJson(Map<String, dynamic> json) {
    return ReceiptVoucherStatisticsModel(
      total: json['total'] as int? ?? 0,
      completed: json['completed'] as int? ?? 0,
      pending: json['pending'] as int? ?? 0,
      accepted: json['accepted'] as int? ?? 0,
      cancelled: json['cancelled'] as int? ?? 0,
      profit: (json['profit'] as num?)?.toDouble() ?? 0.0,
      pendingProfit: (json['pendingProfit'] as num?)?.toDouble() ?? 0.0,
      paidCommissions: (json['paidCommissions'] as num?)?.toDouble() ?? 0.0,
      totalPriceCompleted: (json['totalPriceCompleted'] as num?)?.toDouble(),
      totalPricePending: (json['totalPricePending'] as num?)?.toDouble(),
      totalPriceAccepted: (json['totalPriceAccepted'] as num?)?.toDouble(),
      totalPriceCancelled: (json['totalPriceCancelled'] as num?)?.toDouble(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'completed': completed,
      'pending': pending,
      'accepted': accepted,
      'cancelled': cancelled,
      'profit': profit,
      'pendingProfit': pendingProfit,
      'paidCommissions': paidCommissions,
      'totalPriceCompleted': totalPriceCompleted,
      'totalPricePending': totalPricePending,
      'totalPriceAccepted': totalPriceAccepted,
      'totalPriceCancelled': totalPriceCancelled,
      'totalPrice': totalPrice,
    };
  }
}


