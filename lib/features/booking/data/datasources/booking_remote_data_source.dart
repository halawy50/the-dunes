import 'package:the_dunes/core/data/models/paginated_response.dart';
import 'package:the_dunes/core/network/api_client.dart';
import 'package:the_dunes/core/network/api_constants.dart';
import 'package:the_dunes/core/network/api_exception.dart';
import 'package:the_dunes/features/booking/data/models/booking_model.dart';

class BookingRemoteDataSource {
  final ApiClient apiClient;

  BookingRemoteDataSource(this.apiClient);

  Future<PaginatedResponse<BookingModel>> getBookings({
    int? employeeId,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };
      if (employeeId != null) {
        queryParams['employeeId'] = employeeId.toString();
      }
      final response = await apiClient.get(
        ApiConstants.bookingsEndpoint,
        queryParams: queryParams,
      );
      return PaginatedResponse.fromJson(
        response,
        (json) => BookingModel.fromJson(json as Map<String, dynamic>),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  Future<BookingModel> getBookingById(int id) async {
    try {
      final response = await apiClient.get(
        ApiConstants.bookingByIdEndpoint(id),
      );
      return BookingModel.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  Future<BookingModel> createBooking(BookingModel booking) async {
    try {
      final response = await apiClient.post(
        ApiConstants.bookingsEndpoint,
        booking.toJson(),
      );
      return BookingModel.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  Future<BookingModel> updateBooking(int id, Map<String, dynamic> updates) async {
    try {
      final response = await apiClient.put(
        ApiConstants.bookingByIdEndpoint(id),
        updates,
      );
      return BookingModel.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  Future<void> deleteBooking(int id) async {
    try {
      await apiClient.delete(ApiConstants.bookingByIdEndpoint(id));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }
}

