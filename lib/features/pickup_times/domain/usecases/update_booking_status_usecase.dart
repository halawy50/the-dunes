import 'package:the_dunes/features/pickup_times/domain/repositories/pickup_times_repository.dart';

class UpdateBookingStatusUseCase {
  final PickupTimesRepository repository;

  UpdateBookingStatusUseCase(this.repository);

  Future<Map<String, dynamic>> call({
    required int bookingId,
    String? status,
    String? pickupStatus,
  }) async {
    return await repository.updateBookingStatus(
      bookingId: bookingId,
      status: status,
      pickupStatus: pickupStatus,
    );
  }
}

