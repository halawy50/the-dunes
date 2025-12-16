import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:the_dunes/core/data/models/paginated_response.dart';
import 'package:the_dunes/core/network/api_client.dart';
import 'package:the_dunes/core/network/api_constants.dart';
import 'package:the_dunes/core/network/api_exception.dart';
import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_model.dart';
import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_filter_model.dart';

class ReceiptVoucherRemoteDataSource {
  final ApiClient apiClient;

  ReceiptVoucherRemoteDataSource(this.apiClient);

  Future<PaginatedResponse<ReceiptVoucherModel>> getReceiptVouchers({
    int? employeeId,
    int page = 1,
    int pageSize = 20,
    ReceiptVoucherFilterModel? filter,
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
        ApiConstants.receiptVouchersEndpoint,
        queryParams: queryParams,
      );
      
      if (kDebugMode) {
        print('[ReceiptVoucherRemoteDataSource] Response keys: ${response.keys}');
        print('[ReceiptVoucherRemoteDataSource] Data length: ${(response['data'] as List?)?.length ?? 0}');
        print('[ReceiptVoucherRemoteDataSource] Statistics: ${response['statistics']}');
        if (response['statistics'] != null) {
          print('[ReceiptVoucherRemoteDataSource] Statistics type: ${response['statistics'].runtimeType}');
          print('[ReceiptVoucherRemoteDataSource] Statistics content: ${response['statistics']}');
        }
      }
      
      return PaginatedResponse.fromJson(
        response,
        (json) => ReceiptVoucherModel.fromJson(json as Map<String, dynamic>),
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

  Future<ReceiptVoucherModel> getReceiptVoucherById(int id) async {
    try {
      final response = await apiClient.get(
        ApiConstants.receiptVoucherByIdEndpoint(id),
      );
      return ReceiptVoucherModel.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  Future<ReceiptVoucherModel> createReceiptVoucher(ReceiptVoucherModel voucher) async {
    try {
      final response = await apiClient.post(
        ApiConstants.receiptVouchersEndpoint,
        voucher.toJson(),
      );
      return ReceiptVoucherModel.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  Future<ReceiptVoucherModel> updateReceiptVoucher(
    int id,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await apiClient.put(
        ApiConstants.receiptVoucherByIdEndpoint(id),
        updates,
      );
      return ReceiptVoucherModel.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  Future<ReceiptVoucherModel> updateReceiptVoucherStatus(int id, String status) async {
    try {
      final response = await apiClient.put(
        ApiConstants.receiptVoucherStatusEndpoint(id),
        {},
        queryParams: {'status': status},
      );
      return ReceiptVoucherModel.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  Future<ReceiptVoucherModel> updateReceiptVoucherPickupStatus(
    int id,
    String status,
  ) async {
    try {
      final response = await apiClient.put(
        ApiConstants.receiptVoucherPickupStatusEndpoint(id),
        {},
        queryParams: {'status': status},
      );
      return ReceiptVoucherModel.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  Future<void> deleteReceiptVoucher(int id) async {
    try {
      await apiClient.delete(ApiConstants.receiptVoucherByIdEndpoint(id));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  Future<String> getReceiptVoucherPdf(int id) async {
    try {
      final response = await apiClient.get(
        ApiConstants.receiptVoucherPdfEndpoint(id),
      );
      return response['data'] as String;
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

