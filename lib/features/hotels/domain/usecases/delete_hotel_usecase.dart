import 'package:the_dunes/features/hotels/domain/repositories/hotel_repository.dart';

class DeleteHotelUseCase {
  final HotelRepository repository;

  DeleteHotelUseCase(this.repository);

  Future<void> call(int id) {
    return repository.deleteHotel(id);
  }
}


