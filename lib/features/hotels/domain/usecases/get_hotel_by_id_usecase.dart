import 'package:the_dunes/features/hotels/domain/entities/hotel_entity.dart';
import 'package:the_dunes/features/hotels/domain/repositories/hotel_repository.dart';

class GetHotelByIdUseCase {
  final HotelRepository repository;

  GetHotelByIdUseCase(this.repository);

  Future<HotelEntity> call(int id) {
    return repository.getHotelById(id);
  }
}


