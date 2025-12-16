import 'package:the_dunes/core/data/models/paginated_response.dart';
import 'package:the_dunes/core/network/api_client.dart';
import 'package:the_dunes/core/network/api_constants.dart';
import 'package:the_dunes/core/network/api_exception.dart';
import 'package:the_dunes/features/hotels/data/models/hotel_model.dart';

class HotelRemoteDataSource {
  final ApiClient apiClient;

  HotelRemoteDataSource(this.apiClient);

  Future<PaginatedResponse<HotelModel>> getHotels({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await apiClient.get(
        ApiConstants.hotelsEndpoint,
        queryParams: {
          'page': page.toString(),
          'pageSize': pageSize.toString(),
        },
      );
      return PaginatedResponse.fromJson(
        response,
        (json) => HotelModel.fromJson(json as Map<String, dynamic>),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<List<HotelModel>> getAllHotels() async {
    try {
      final response = await apiClient.get(ApiConstants.hotelsAllEndpoint);
      final data = response['data'] as List<dynamic>? ?? [];
      return data.map((json) => HotelModel.fromJson(json)).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<HotelModel> getHotelById(int id) async {
    try {
      final response = await apiClient.get(
        ApiConstants.hotelByIdEndpoint(id),
      );
      return HotelModel.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<HotelModel> createHotel(String name) async {
    try {
      final response = await apiClient.post(
        ApiConstants.hotelsEndpoint,
        {'nameHotel': name},
      );
      return HotelModel.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<HotelModel> updateHotel(int id, String name) async {
    try {
      final response = await apiClient.put(
        ApiConstants.hotelByIdEndpoint(id),
        {'nameHotel': name},
      );
      return HotelModel.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<void> deleteHotel(int id) async {
    try {
      await apiClient.delete(ApiConstants.hotelByIdEndpoint(id));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }
}

