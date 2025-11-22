class BookingServiceModel {
  final int id;
  final int serviceId;
  final String? serviceName;
  final int? locationId;
  final int adultNumber;
  final int childNumber;
  final int kidNumber;
  final double adultPrice;
  final double childPrice;
  final double kidPrice;
  final double totalPriceService;

  BookingServiceModel({
    required this.id,
    required this.serviceId,
    this.serviceName,
    this.locationId,
    required this.adultNumber,
    required this.childNumber,
    required this.kidNumber,
    required this.adultPrice,
    required this.childPrice,
    required this.kidPrice,
    required this.totalPriceService,
  });

  factory BookingServiceModel.fromJson(Map<String, dynamic> json) {
    return BookingServiceModel(
      id: json['id'] ?? 0,
      serviceId: json['serviceId'] ?? 0,
      serviceName: json['serviceName'],
      locationId: json['locationId'],
      adultNumber: json['adultNumber'] ?? 0,
      childNumber: json['childNumber'] ?? 0,
      kidNumber: json['kidNumber'] ?? 0,
      adultPrice: (json['adultPrice'] ?? 0.0).toDouble(),
      childPrice: (json['childPrice'] ?? 0.0).toDouble(),
      kidPrice: (json['kidPrice'] ?? 0.0).toDouble(),
      totalPriceService: (json['totalPriceService'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'serviceId': serviceId,
      'adultNumber': adultNumber,
      'childNumber': childNumber,
      'kidNumber': kidNumber,
    };
    
    // Only include locationId if it's not null and not -1 (Global)
    if (locationId != null && locationId! > 0) {
      json['locationId'] = locationId;
    }
    
    return json;
  }
}


