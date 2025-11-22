import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:the_dunes/core/app_router/app_router.dart';
import 'package:the_dunes/core/data/datasources/token_storage.dart';
import 'package:the_dunes/core/network/api_exception.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';

class ApiResponseHandler {
  static Map<String, dynamic> handleResponse(http.Response response) {
    if (response.statusCode == 401) {
      // Try to get error message from server response
      String serverMessage = 'errors.not_logged_in'.tr();
      
      try {
        if (response.body.isNotEmpty) {
          final errorJson = jsonDecode(response.body) as Map<String, dynamic>?;
          if (errorJson != null) {
            // Try to get message from server response
            final message = errorJson['message'] as String? ?? 
                          errorJson['error'] as String?;
            if (message != null && message.isNotEmpty) {
              serverMessage = message;
              print('[ApiResponseHandler] ✅ Using server message: $serverMessage');
            } else {
              print('[ApiResponseHandler] ⚠️ No message in server response, using default');
            }
          }
        }
      } catch (e) {
        print('[ApiResponseHandler] ⚠️ Failed to parse 401 response: $e');
        print('[ApiResponseHandler] Response body: ${response.body}');
      }
      
      _handleUnauthorized(serverMessage);
      throw ApiException(
        message: serverMessage,
        statusCode: 401,
      );
    }
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return _handleSuccessResponse(response);
    } else {
      return _handleErrorResponse(response);
    }
  }

  static Map<String, dynamic> _handleSuccessResponse(http.Response response) {
    try {
      if (response.body.isEmpty) {
        return {};
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw ApiException(
        message: 'errors.invalid_response'.tr(),
        error: e.toString(),
        statusCode: response.statusCode,
      );
    }
  }

  static Map<String, dynamic> _handleErrorResponse(http.Response response) {
    try {
      if (response.body.isNotEmpty) {
        final error = jsonDecode(response.body) as Map<String, dynamic>;
        final message = error['message'] as String? ?? 
                       error['error'] as String? ?? 
                       'errors.request_failed'.tr();
        throw ApiException(
          message: message,
          error: error['error'] as String?,
          statusCode: response.statusCode,
        );
      } else {
        throw ApiException.fromStatusCode(
          response.statusCode,
          null,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException.fromStatusCode(
        response.statusCode,
        'errors.parse_error'.tr(),
      );
    }
  }

  static void _handleUnauthorized(String message) {
    TokenStorage.deleteToken();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navigatorContext = AppRouter.navbarKey.currentContext;
      if (navigatorContext != null) {
        // Check if message is a translation key (contains dots) or plain text from API
        if (message.contains('.') && 
            !message.contains(' ') &&
            message.split('.').length >= 2) {
          // It's a translation key
          AppSnackbar.showTranslated(
            context: navigatorContext,
            translationKey: message,
            type: SnackbarType.error,
          );
        } else {
          // It's a plain text message from server
          AppSnackbar.show(
            context: navigatorContext,
            message: message,
            type: SnackbarType.error,
          );
        }
        Future.delayed(const Duration(milliseconds: 500), () {
          if (navigatorContext.mounted) {
            navigatorContext.go(AppRouter.login);
          }
        });
      }
    });
  }
}

