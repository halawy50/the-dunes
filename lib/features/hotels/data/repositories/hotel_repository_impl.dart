import 'package:the_dunes/core/data/models/paginated_response.dart';
import 'package:the_dunes/features/hotels/data/datasources/hotel_remote_data_source.dart';
import 'package:the_dunes/features/hotels/domain/entities/hotel_entity.dart';
import 'package:the_dunes/features/hotels/domain/repositories/hotel_repository.dart';

class HotelRepositoryImpl implements HotelRepository {
  final HotelRemoteDataSource dataSource;

  HotelRepositoryImpl(this.dataSource);

  @override
  Future<PaginatedResponse<HotelEntity>> getHotels({
    int page = 1,
    int pageSize = 20,
  }) async {
    final result = await dataSource.getHotels(page: page, pageSize: pageSize);
    return PaginatedResponse<HotelEntity>(
      success: result.success,
      message: result.message,
      data: result.data,
      pagination: result.pagination,
    );
  }

  @override
  Future<List<HotelEntity>> getAllHotels() async {
    return await dataSource.getAllHotels();
  }

  @override
  Future<HotelEntity> getHotelById(int id) async {
    return await dataSource.getHotelById(id);
  }

  @override
  Future<HotelEntity> createHotel(String name) async {
    return await dataSource.createHotel(name);
  }

  @override
  Future<HotelEntity> updateHotel(int id, String name) async {
    return await dataSource.updateHotel(id, name);
  }

  @override
  Future<void> deleteHotel(int id) async {
    return await dataSource.deleteHotel(id);
  }
}

