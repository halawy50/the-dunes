import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/data/datasources/auth_remote_data_source.dart';
import 'package:the_dunes/core/data/datasources/token_storage.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart' as di;
import 'package:the_dunes/core/network/api_client.dart';
import 'package:the_dunes/core/network/api_exception.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/features/login/data/models/permissions_model.dart';
import 'app_router.dart';

class AppRouterRedirect {
  static Future<String?> redirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final token = await TokenStorage.getToken();
    final path = state.uri.path;
    final isLoginPage = path == AppRouter.login;
    
    if (token == null) {
      if (!isLoginPage) return AppRouter.login;
      return null;
    }
    
    try {
      final apiClient = di.di<ApiClient>();
      apiClient.setToken(token);
      final authDataSource = AuthRemoteDataSource(apiClient);
      final response = await authDataSource.checkToken();
      
      if (response['success'] == true && 
          response['data'] != null &&
          response['data']['isValid'] == true) {
        final data = response['data'] as Map<String, dynamic>;
        if (data['employee'] != null) {
          final employee = data['employee'] as Map<String, dynamic>;
          
          if (employee['permissions'] != null) {
            final permissions = PermissionsModel.fromJson(
              employee['permissions'] as Map<String, dynamic>,
            );
            await TokenStorage.savePermissions(permissions);
          }
          
          await TokenStorage.saveUserData({
            'id': employee['id'],
            'name': employee['name'],
            'email': employee['email'],
            'image': employee['image'],
          });
        }
        
        if (isLoginPage) return AppRouter.home;
        
        final section = AppRouter.getSectionFromPath(path);
        if (section == null && path != '/') {
          return AppRouter.home;
        }
        
        return null;
      } else {
        await TokenStorage.deleteToken();
        if (!isLoginPage) return AppRouter.login;
        return null;
      }
    } catch (e) {
      if (e is ApiException && e.statusCode == 401) {
        await TokenStorage.deleteToken();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final navigatorContext = AppRouter.navbarKey.currentContext;
          if (navigatorContext != null) {
            AppSnackbar.showTranslated(
              context: navigatorContext,
              translationKey: 'errors.not_logged_in',
              type: SnackbarType.error,
            );
          }
        });
        if (!isLoginPage) return AppRouter.login;
        return null;
      }
      if (isLoginPage) return null;
      await TokenStorage.deleteToken();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final navigatorContext = AppRouter.navbarKey.currentContext;
        if (navigatorContext != null) {
          AppSnackbar.showTranslated(
            context: navigatorContext,
            translationKey: 'errors.not_logged_in',
            type: SnackbarType.error,
          );
        }
      });
      return AppRouter.login;
    }
  }
}

