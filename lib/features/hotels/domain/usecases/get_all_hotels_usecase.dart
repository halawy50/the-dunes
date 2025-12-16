import 'package:the_dunes/features/hotels/domain/entities/hotel_entity.dart';
import 'package:the_dunes/features/hotels/domain/repositories/hotel_repository.dart';

class GetAllHotelsUseCase {
  final HotelRepository repository;

  GetAllHotelsUseCase(this.repository);

  Future<List<HotelEntity>> call() {
    return repository.getAllHotels();
  }
}


