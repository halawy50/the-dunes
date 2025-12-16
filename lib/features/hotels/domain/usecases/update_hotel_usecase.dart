import 'package:the_dunes/features/hotels/domain/entities/hotel_entity.dart';
import 'package:the_dunes/features/hotels/domain/repositories/hotel_repository.dart';

class UpdateHotelUseCase {
  final HotelRepository repository;

  UpdateHotelUseCase(this.repository);

  Future<HotelEntity> call(int id, String name) {
    return repository.updateHotel(id, name);
  }
}


