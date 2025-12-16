import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:the_dunes/core/network/api_client.dart';
import 'package:the_dunes/core/network/api_constants.dart';
import 'package:the_dunes/core/network/api_exception.dart';
import 'package:the_dunes/features/pickup_times/data/models/pickup_times_model.dart';

import 'package:the_dunes/features/pickup_times/data/models/vehicle_group_simple_model.dart';

abstract class PickupTimesRemoteDataSource {
  Future<PickupTimesModel> getPickupTimes();
  Future<List<VehicleGroupSimpleModel>> getVehicleGroups();
  Future<Map<String, dynamic>> assignVehicle({
    required int carNumber,
    String? driver,
    List<int>? bookingIds,
    List<int>? voucherIds,
  });
  Future<Map<String, dynamic>> updateAssignment({
    required String pickupGroupId,
    int? carNumber,
    String? driver,
    List<int>? addBookingIds,
    List<int>? addVoucherIds,
    List<int>? removeBookingIds,
    List<int>? removeVoucherIds,
  });
  Future<Map<String, dynamic>> removeAssignment({
    List<int>? bookingIds,
    List<int>? voucherIds,
  });
  Future<Map<String, dynamic>> updateVoucherStatus({
    required int voucherId,
    String? status,
    String? pickupStatus,
  });
  Future<Map<String, dynamic>> updateBookingStatus({
    required int bookingId,
    String? status,
    String? pickupStatus,
  });
  Future<Map<String, dynamic>> updatePickupTimeStatus({
    required int id,
    required String type,
    required String status,
    required String statusType,
  });
}

class PickupTimesRemoteDataSourceImpl implements PickupTimesRemoteDataSource {
  final ApiClient apiClient;

  PickupTimesRemoteDataSourceImpl(this.apiClient);

  @override
  Future<PickupTimesModel> getPickupTimes() async {
    try {
      if (kDebugMode) {
        print('[PickupTimesRemoteDataSource] Fetching pickup times from: ${ApiConstants.pickupTimesEndpoint}');
      }
      final response = await apiClient.get(ApiConstants.pickupTimesEndpoint);
      if (kDebugMode) {
        print('[PickupTimesRemoteDataSource] Response received: ${response.keys}');
        print('[PickupTimesRemoteDataSource] Has data key: ${response.containsKey('data')}');
      }
      final model = PickupTimesModel.fromJson(response);
      if (kDebugMode) {
        print('[PickupTimesRemoteDataSource] Model created successfully');
      }
      return model;
    } on ApiException {
      rethrow;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('[PickupTimesRemoteDataSource] Error: $e');
        print('[PickupTimesRemoteDataSource] Stack trace: $stackTrace');
      }
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<List<VehicleGroupSimpleModel>> getVehicleGroups() async {
    try {
      if (kDebugMode) {
        print('[PickupTimesRemoteDataSource] Fetching vehicle groups from: ${ApiConstants.pickupTimesGroupsEndpoint}');
      }
      final response = await apiClient.get(ApiConstants.pickupTimesGroupsEndpoint);
      final data = response['data'] as Map<String, dynamic>? ?? {};
      final groups = data['groups'] as List<dynamic>? ?? [];
      final models = groups
          .map((e) => VehicleGroupSimpleModel.fromJson(e as Map<String, dynamic>))
          .toList();
      if (kDebugMode) {
        print('[PickupTimesRemoteDataSource] Loaded ${models.length} vehicle groups');
      }
      return models;
    } on ApiException {
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('[PickupTimesRemoteDataSource] Error in getVehicleGroups: $e');
      }
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<Map<String, dynamic>> assignVehicle({
    required int carNumber,
    String? driver,
    List<int>? bookingIds,
    List<int>? voucherIds,
  }) async {
    try {
      final body = <String, dynamic>{
        'carNumber': carNumber,
      };
      if (driver != null) body['driver'] = driver;
      if (bookingIds != null && bookingIds.isNotEmpty) {
        body['bookingIds'] = bookingIds;
      }
      if (voucherIds != null && voucherIds.isNotEmpty) {
        body['voucherIds'] = voucherIds;
      }
      final response = await apiClient.post(
        ApiConstants.pickupTimesAssignVehicleEndpoint,
        body,
      );
      return response['data'] as Map<String, dynamic>? ?? {};
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<Map<String, dynamic>> updateAssignment({
    required String pickupGroupId,
    int? carNumber,
    String? driver,
    List<int>? addBookingIds,
    List<int>? addVoucherIds,
    List<int>? removeBookingIds,
    List<int>? removeVoucherIds,
  }) async {
    try {
      final body = <String, dynamic>{
        'pickupGroupId': pickupGroupId,
      };
      if (carNumber != null) body['carNumber'] = carNumber;
      if (driver != null) body['driver'] = driver;
      if (addBookingIds != null && addBookingIds.isNotEmpty) {
        body['addBookingIds'] = addBookingIds;
      }
      if (addVoucherIds != null && addVoucherIds.isNotEmpty) {
        body['addVoucherIds'] = addVoucherIds;
      }
      if (removeBookingIds != null && removeBookingIds.isNotEmpty) {
        body['removeBookingIds'] = removeBookingIds;
      }
      if (removeVoucherIds != null && removeVoucherIds.isNotEmpty) {
        body['removeVoucherIds'] = removeVoucherIds;
      }
      final response = await apiClient.put(
        ApiConstants.pickupTimesUpdateAssignmentEndpoint,
        body,
      );
      return response['data'] as Map<String, dynamic>? ?? {};
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<Map<String, dynamic>> removeAssignment({
    List<int>? bookingIds,
    List<int>? voucherIds,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (bookingIds != null && bookingIds.isNotEmpty) {
        body['bookingIds'] = bookingIds;
      }
      if (voucherIds != null && voucherIds.isNotEmpty) {
        body['voucherIds'] = voucherIds;
      }
      final response = await apiClient.post(
        ApiConstants.pickupTimesRemoveAssignmentEndpoint,
        body,
      );
      return response['data'] as Map<String, dynamic>? ?? {};
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<Map<String, dynamic>> updateVoucherStatus({
    required int voucherId,
    String? status,
    String? pickupStatus,
  }) async {
    try {
      if (pickupStatus != null) {
        final response = await apiClient.put(
          ApiConstants.receiptVoucherPickupStatusEndpoint(voucherId),
          {},
          queryParams: {'status': pickupStatus},
        );
        return response['data'] as Map<String, dynamic>? ?? {};
      }
      if (status != null) {
        final body = <String, dynamic>{'status': status};
        final response = await apiClient.put(
          ApiConstants.receiptVoucherByIdEndpoint(voucherId),
          body,
        );
        return response['data'] as Map<String, dynamic>? ?? {};
      }
      return {};
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<Map<String, dynamic>> updateBookingStatus({
    required int bookingId,
    String? status,
    String? pickupStatus,
  }) async {
    try {
      if (pickupStatus != null) {
        final response = await apiClient.put(
          ApiConstants.bookingPickupStatusEndpoint(bookingId),
          {},
          queryParams: {'status': pickupStatus},
        );
        return response['data'] as Map<String, dynamic>? ?? {};
      }
      if (status != null) {
        final response = await apiClient.put(
          ApiConstants.bookingStatusEndpoint(bookingId),
          {},
          queryParams: {'status': status},
        );
        return response['data'] as Map<String, dynamic>? ?? {};
      }
      return {};
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<Map<String, dynamic>> updatePickupTimeStatus({
    required int id,
    required String type,
    required String status,
    required String statusType,
  }) async {
    try {
      if (kDebugMode) {
        print('[PickupTimesRemoteDataSource] Updating status via pickup-time endpoint');
        print('[PickupTimesRemoteDataSource] ID: $id, Type: $type, Status: $status, StatusType: $statusType');
      }
      final body = <String, dynamic>{
        'id': id,
        'type': type,
        'status': status,
        'statusType': statusType,
      };
      final response = await apiClient.put(
        ApiConstants.pickupTimesUpdateStatusEndpoint,
        body,
      );
      if (kDebugMode) {
        print('[PickupTimesRemoteDataSource] Status updated successfully');
      }
      return response['data'] as Map<String, dynamic>? ?? {};
    } on ApiException {
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('[PickupTimesRemoteDataSource] Error updating status: $e');
      }
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }
}

