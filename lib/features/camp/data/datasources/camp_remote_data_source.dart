import 'package:the_dunes/core/network/api_client.dart';
import 'package:the_dunes/core/network/api_constants.dart';
import 'package:the_dunes/core/network/api_exception.dart';
import 'package:the_dunes/features/camp/data/models/camp_data_model.dart';

class CampRemoteDataSource {
  final ApiClient apiClient;

  CampRemoteDataSource(this.apiClient);

  Future<CampDataModel> getCampData() async {
    try {
      final response = await apiClient.get(ApiConstants.campEndpoint);
      return CampDataModel.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<void> updateBookingStatus(int bookingId, String status) async {
    try {
      await apiClient.put(
        ApiConstants.campBookingStatusEndpoint(bookingId),
        {'status': status},
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<void> updateVoucherStatus(int voucherId, String status) async {
    try {
      await apiClient.put(
        ApiConstants.campVoucherStatusEndpoint(voucherId),
        {'status': status},
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }
}

