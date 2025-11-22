import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/data/datasources/token_storage.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart' as di;
import 'package:the_dunes/core/network/api_client.dart';
import 'app_router.dart';

class AppRouterRedirect {
  static Future<String?> redirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final token = await TokenStorage.getToken();
    final path = state.uri.path;
    final isLoginPage = path == AppRouter.login;
    
    // If no token, redirect to login (except if already on login page)
    if (token == null) {
      if (!isLoginPage) return AppRouter.login;
      return null;
    }
    
    // If token exists, set it in ApiClient and allow access
    // Don't check token here - let the actual API calls handle 401 errors
    final apiClient = di.di<ApiClient>();
    apiClient.setToken(token);
    
    // If on login page and token exists, redirect to home
    // (LoginScreen will check token validity)
    if (isLoginPage) {
      return null; // Let LoginScreen handle the check
    }
    
    // For other pages, just check if path is valid
    final section = AppRouter.getSectionFromPath(path);
    if (section == null && path != '/') {
      return AppRouter.home;
    }
    
    return null;
  }
}

