import 'package:the_dunes/features/booking/data/models/document_analysis_service_model.dart';

class AnalyzedDataModel {
  final String guestName;
  final String? phoneNumber;
  final String? hotelName;
  final int? room;
  final String? agentName;
  final String? locationName;
  final List<DocumentAnalysisServiceModel> services;
  final String? pickupTime;
  final String? payment;
  final double? finalPrice;
  final double? confidence;

  AnalyzedDataModel({
    required this.guestName,
    this.phoneNumber,
    this.hotelName,
    this.room,
    this.agentName,
    this.locationName,
    required this.services,
    this.pickupTime,
    this.payment,
    this.finalPrice,
    this.confidence,
  });

  factory AnalyzedDataModel.fromJson(Map<String, dynamic> json) {
    return AnalyzedDataModel(
      guestName: json['guestName'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      hotelName: json['hotelName'] as String?,
      room: json['room'] as int?,
      agentName: json['agentName'] as String?,
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
      confidence: (json['confidence'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'guestName': guestName,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (hotelName != null) 'hotelName': hotelName,
      if (room != null) 'room': room,
      if (agentName != null) 'agentName': agentName,
      if (locationName != null) 'locationName': locationName,
      'services': services.map((e) => e.toJson()).toList(),
      if (pickupTime != null) 'pickupTime': pickupTime,
      if (payment != null) 'payment': payment,
      if (finalPrice != null) 'finalPrice': finalPrice,
      if (confidence != null) 'confidence': confidence,
    };
  }
}

