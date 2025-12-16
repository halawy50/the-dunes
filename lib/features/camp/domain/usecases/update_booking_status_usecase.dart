import 'package:the_dunes/features/camp/domain/repositories/camp_repository.dart';

class UpdateBookingStatusUseCase {
  final CampRepository repository;

  UpdateBookingStatusUseCase(this.repository);

  Future<void> call(int bookingId, String status) async {
    return await repository.updateBookingStatus(bookingId, status);
  }
}

