import 'package:the_dunes/features/booking/data/models/document_analysis_service_model.dart';

class MatchedDataModel {
  final String guestName;
  final String? phoneNumber;
  final String? hotelName;
  final int? room;
  final int? agentId;
  final String? agentName;
  final int? locationId;
  final String? locationName;
  final List<DocumentAnalysisServiceModel> services;
  final String? pickupTime;
  final String? payment;
  final double? finalPrice;
  final int? currencyId;
  final String? currencyName;
  final double? confidence;
  final List<String> warnings;
  final List<String> errors;

  MatchedDataModel({
    required this.guestName,
    this.phoneNumber,
    this.hotelName,
    this.room,
    this.agentId,
    this.agentName,
    this.locationId,
    this.locationName,
    required this.services,
    this.pickupTime,
    this.payment,
    this.finalPrice,
    this.currencyId,
    this.currencyName,
    this.confidence,
    required this.warnings,
    required this.errors,
  });

  factory MatchedDataModel.fromJson(Map<String, dynamic> json) {
    return MatchedDataModel(
      guestName: json['guestName'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      hotelName: json['hotelName'] as String?,
      room: json['room'] as int?,
      agentId: json['agentId'] as int?,
      agentName: json['agentName'] as String?,
      locationId: json['locationId'] as int?,
      locationName: json['locationName'] as String?,
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => DocumentAnalysisServiceModel.fromJson(
                    e as Map<String, dynamic>,
                  ))
              .toList() ??
          [],
      pickupTime: json['pickupTime'] as String?,
      payment: json['payment'] as String?,
      finalPrice: (json['finalPrice'] as num?)?.toDouble(),
      currencyId: json['currencyId'] as int?,
      currencyName: json['currencyName'] as String?,
      confidence: (json['confidence'] as num?)?.toDouble(),
      warnings: (json['warnings'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      errors: (json['errors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'guestName': guestName,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (hotelName != null) 'hotelName': hotelName,
      if (room != null) 'room': room,
      if (agentId != null) 'agentId': agentId,
      if (agentName != null) 'agentName': agentName,
      if (locationId != null) 'locationId': locationId,
      if (locationName != null) 'locationName': locationName,
      'services': services.map((e) => e.toJson()).toList(),
      if (pickupTime != null) 'pickupTime': pickupTime,
      if (payment != null) 'payment': payment,
      if (finalPrice != null) 'finalPrice': finalPrice,
      if (currencyId != null) 'currencyId': currencyId,
      if (currencyName != null) 'currencyName': currencyName,
      if (confidence != null) 'confidence': confidence,
      'warnings': warnings,
      'errors': errors,
    };
  }
}

