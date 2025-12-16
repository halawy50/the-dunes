class DocumentAnalysisServiceModel {
  final int? serviceId;
  final String serviceName;
  final int? locationId;
  final String? locationName;
  final int adultNumber;
  final int childNumber;
  final int kidNumber;
  final double? adultPrice;
  final double? childPrice;
  final double? kidPrice;
  final double? totalPrice;
  final bool? matched;

  DocumentAnalysisServiceModel({
    this.serviceId,
    required this.serviceName,
    this.locationId,
    this.locationName,
    required this.adultNumber,
    required this.childNumber,
    required this.kidNumber,
    this.adultPrice,
    this.childPrice,
    this.kidPrice,
    this.totalPrice,
    this.matched,
  });

  factory DocumentAnalysisServiceModel.fromJson(Map<String, dynamic> json) {
    return DocumentAnalysisServiceModel(
      serviceId: json['serviceId'] as int?,
      serviceName: json['serviceName'] as String,
      locationId: json['locationId'] as int?,
      locationName: json['locationName'] as String?,
      adultNumber: json['adultNumber'] as int? ?? 0,
      childNumber: json['childNumber'] as int? ?? 0,
      kidNumber: json['kidNumber'] as int? ?? 0,
      adultPrice: (json['adultPrice'] as num?)?.toDouble(),
      childPrice: (json['childPrice'] as num?)?.toDouble(),
      kidPrice: (json['kidPrice'] as num?)?.toDouble(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      matched: json['matched'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (serviceId != null) 'serviceId': serviceId,
      'serviceName': serviceName,
      if (locationId != null) 'locationId': locationId,
      if (locationName != null) 'locationName': locationName,
      'adultNumber': adultNumber,
      'childNumber': childNumber,
      'kidNumber': kidNumber,
      if (adultPrice != null) 'adultPrice': adultPrice,
      if (childPrice != null) 'childPrice': childPrice,
      if (kidPrice != null) 'kidPrice': kidPrice,
      if (totalPrice != null) 'totalPrice': totalPrice,
      if (matched != null) 'matched': matched,
    };
  }
}

