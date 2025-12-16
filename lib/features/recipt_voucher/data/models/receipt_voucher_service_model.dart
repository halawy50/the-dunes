class ReceiptVoucherServiceModel {
  final int id;
  final int serviceId;
  final String? serviceName;
  final int adultNumber;
  final int childNumber;
  final int kidNumber;
  final double adultPrice;
  final double childPrice;
  final double kidPrice;
  final double totalPrice;

  ReceiptVoucherServiceModel({
    required this.id,
    required this.serviceId,
    this.serviceName,
    required this.adultNumber,
    required this.childNumber,
    required this.kidNumber,
    required this.adultPrice,
    required this.childPrice,
    required this.kidPrice,
    required this.totalPrice,
  });

  factory ReceiptVoucherServiceModel.fromJson(Map<String, dynamic> json) {
    return ReceiptVoucherServiceModel(
      id: json['id'] ?? 0,
      serviceId: json['serviceId'] ?? 0,
      serviceName: json['serviceName'],
      adultNumber: json['adultNumber'] ?? 0,
      childNumber: json['childNumber'] ?? 0,
      kidNumber: json['kidNumber'] ?? 0,
      adultPrice: (json['adultPrice'] ?? 0.0).toDouble(),
      childPrice: (json['childPrice'] ?? 0.0).toDouble(),
      kidPrice: (json['kidPrice'] ?? 0.0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'adultNumber': adultNumber,
      'childNumber': childNumber,
      'kidNumber': kidNumber,
      'adultPrice': adultPrice,
      'childPrice': childPrice,
      'kidPrice': kidPrice,
    };
  }
}

