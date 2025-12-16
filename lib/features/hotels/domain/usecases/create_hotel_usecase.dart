import 'package:the_dunes/features/hotels/domain/entities/hotel_entity.dart';
import 'package:the_dunes/features/hotels/domain/repositories/hotel_repository.dart';

class CreateHotelUseCase {
  final HotelRepository repository;

  CreateHotelUseCase(this.repository);

  Future<HotelEntity> call(String name) {
    return repository.createHotel(name);
  }
}


