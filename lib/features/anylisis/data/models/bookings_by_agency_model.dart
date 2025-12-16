import 'package:the_dunes/features/anylisis/domain/entities/bookings_by_agency_entity.dart';

class AgencyBookingModel extends AgencyBookingEntity {
  const AgencyBookingModel({
    required super.agentId,
    required super.agentName,
    required super.bookingCount,
  });

  factory AgencyBookingModel.fromJson(Map<String, dynamic> json) {
    return AgencyBookingModel(
      agentId: json['agentId'] as int? ?? 0,
      agentName: json['agentName'] as String? ?? '',
      bookingCount: json['bookingCount'] as int? ?? 0,
    );
  }
}

class BookingsByAgencyModel extends BookingsByAgencyEntity {
  const BookingsByAgencyModel({
    required super.totalBookings,
    required super.agencies,
  });

  factory BookingsByAgencyModel.fromJson(Map<String, dynamic> json) {
    final agenciesData = json['agencies'] as List<dynamic>? ?? [];
    return BookingsByAgencyModel(
      totalBookings: json['totalBookings'] as int? ?? 0,
      agencies: agenciesData
          .map((item) => AgencyBookingModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

