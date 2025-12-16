import 'package:equatable/equatable.dart';

class AgencyBookingEntity extends Equatable {
  final int agentId;
  final String agentName;
  final int bookingCount;

  const AgencyBookingEntity({
    required this.agentId,
    required this.agentName,
    required this.bookingCount,
  });

  @override
  List<Object?> get props => [agentId, agentName, bookingCount];
}

class BookingsByAgencyEntity extends Equatable {
  final int totalBookings;
  final List<AgencyBookingEntity> agencies;

  const BookingsByAgencyEntity({
    required this.totalBookings,
    required this.agencies,
  });

  @override
  List<Object?> get props => [totalBookings, agencies];
}

