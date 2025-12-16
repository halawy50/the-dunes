import 'package:the_dunes/features/anylisis/domain/entities/bookings_by_agency_entity.dart';
import 'package:the_dunes/features/anylisis/domain/repositories/statistics_repository.dart';

class GetBookingsByAgencyUseCase {
  final StatisticsRepository repository;

  GetBookingsByAgencyUseCase(this.repository);

  Future<BookingsByAgencyEntity> call({
    int? startDate,
    int? endDate,
  }) async {
    return await repository.getBookingsByAgency(
      startDate: startDate,
      endDate: endDate,
    );
  }
}

