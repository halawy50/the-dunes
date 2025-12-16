import 'package:the_dunes/core/data/models/paginated_response.dart';
import 'package:the_dunes/features/hotels/domain/entities/hotel_entity.dart';

abstract class HotelRepository {
  Future<PaginatedResponse<HotelEntity>> getHotels({
    int page = 1,
    int pageSize = 20,
  });
  Future<List<HotelEntity>> getAllHotels();
  Future<HotelEntity> getHotelById(int id);
  Future<HotelEntity> createHotel(String name);
  Future<HotelEntity> updateHotel(int id, String name);
  Future<void> deleteHotel(int id);
}

