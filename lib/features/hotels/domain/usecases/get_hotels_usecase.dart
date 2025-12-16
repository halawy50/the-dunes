import 'package:the_dunes/core/data/models/paginated_response.dart';
import 'package:the_dunes/features/hotels/domain/entities/hotel_entity.dart';
import 'package:the_dunes/features/hotels/domain/repositories/hotel_repository.dart';

class GetHotelsUseCase {
  final HotelRepository repository;

  GetHotelsUseCase(this.repository);

  Future<PaginatedResponse<HotelEntity>> call({
    int page = 1,
    int pageSize = 20,
  }) {
    return repository.getHotels(page: page, pageSize: pageSize);
  }
}

