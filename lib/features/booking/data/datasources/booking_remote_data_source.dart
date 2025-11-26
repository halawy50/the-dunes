import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:the_dunes/core/data/models/paginated_response.dart';
import 'package:the_dunes/core/network/api_client.dart';
import 'package:the_dunes/core/network/api_constants.dart';
import 'package:the_dunes/core/network/api_exception.dart';
import 'package:the_dunes/features/booking/data/models/booking_model.dart';
import 'package:the_dunes/features/booking/data/models/booking_filter_model.dart';

class BookingRemoteDataSource {
  final ApiClient apiClient;

  BookingRemoteDataSource(this.apiClient);

  Future<PaginatedResponse<BookingModel>> getBookings({
    int? employeeId,
    int page = 1,
    int pageSize = 20,
    BookingFilterModel? filter,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };
      if (employeeId != null) {
        queryParams['employeeId'] = employeeId.toString();
      }
      if (filter != null) {
        queryParams.addAll(filter.toQueryParams());
      }
      final response = await apiClient.get(
        ApiConstants.bookingsEndpoint,
        queryParams: queryParams,
      );
      
      // Debug: Log response structure
      if (kDebugMode) {
        print('[BookingRemoteDataSource] Response keys: ${response.keys}');
        print('[BookingRemoteDataSource] Data length: ${(response['data'] as List?)?.length ?? 0}');
        print('[BookingRemoteDataSource] TotalPrice: ${response['totalPrice']}');
        print('[BookingRemoteDataSource] TotalCount: ${response['totalCount']}');
      }
      
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

  Future<BookingModel> updateBookingStatus(int id, String status) async {
    try {
      final response = await apiClient.put(
        ApiConstants.bookingStatusEndpoint(id),
        {},
        queryParams: {'status': status},
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

  Future<BookingModel> updateBookingPickupStatus(int id, String status) async {
    try {
      final response = await apiClient.put(
        ApiConstants.bookingPickupStatusEndpoint(id),
        {},
        queryParams: {'status': status},
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

