import 'package:easy_localization/easy_localization.dart';

class ApiException implements Exception {
  final String message;
  final String? error;
  final int statusCode;

  ApiException({
    required this.message,
    this.error,
    required this.statusCode,
  });

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';

  factory ApiException.fromStatusCode(int statusCode, String? message) {
    switch (statusCode) {
      case 400:
        return ApiException(
          message: message ?? 'errors.bad_request'.tr(),
          statusCode: statusCode,
        );
      case 401:
        return ApiException(
          message: message ?? 'errors.unauthorized'.tr(),
          statusCode: statusCode,
        );
      case 403:
        return ApiException(
          message: message ?? 'errors.forbidden'.tr(),
          statusCode: statusCode,
        );
      case 404:
        return ApiException(
          message: message ?? 'errors.not_found'.tr(),
          statusCode: statusCode,
        );
      case 500:
        return ApiException(
          message: message ?? 'errors.internal_server_error'.tr(),
          statusCode: statusCode,
        );
      default:
        return ApiException(
          message: message ?? 'errors.unknown_error'.tr(),
          statusCode: statusCode,
        );
    }
  }
}

