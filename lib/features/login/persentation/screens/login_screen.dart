import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/utils/constants/assets/images.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/app_router/app_router.dart';
import 'package:the_dunes/core/data/datasources/auth_remote_data_source.dart';
import 'package:the_dunes/core/data/datasources/token_storage.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/core/network/api_client.dart';
import 'package:the_dunes/features/login/data/models/permissions_model.dart';
import 'package:the_dunes/features/login/persentation/cubit/login_cubit.dart';

import '../widgets/login_content.dart';
import '../widgets/login_language_switcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _hasCheckedToken = false;

  @override
  void initState() {
    super.initState();
    _checkTokenAndAutoLogin();
  }

  Future<void> _checkTokenAndAutoLogin() async {
    if (_hasCheckedToken) return;
    _hasCheckedToken = true;

    final token = await TokenStorage.getToken();
    if (token == null || token.isEmpty) {
      print('[LoginScreen] No token found, showing login form');
      return;
    }

    print('[LoginScreen] Token found, checking validity...');
    
    try {
      final apiClient = di<ApiClient>();
      apiClient.setToken(token);
      
      final authDataSource = AuthRemoteDataSource(apiClient);
      final response = await authDataSource.checkToken();
      
      if (response['success'] == true && 
          response['data'] != null &&
          response['data']['isValid'] == true) {
        print('[LoginScreen] ✅ Token is valid, auto-login...');
        
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
        
        // Navigate to first allowed page based on permissions
        if (mounted) {
          final permissions = await TokenStorage.getPermissions();
          final firstRoute = AppRouter.getFirstAllowedRoute(permissions);
          context.go(firstRoute);
        }
      } else {
        print('[LoginScreen] ❌ Token is invalid, showing login form');
        await TokenStorage.deleteToken();
        apiClient.setToken(null);
      }
    } catch (e) {
      print('[LoginScreen] ❌ Error checking token: $e');
      // If 401 or any error, clear token and show login form
      await TokenStorage.deleteToken();
      di<ApiClient>().setToken(null);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<LoginCubit>(),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) async {
          if (state is LoginSuccess) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: 'login.login_success',
              type: SnackbarType.success,
            );
            // Navigate to first allowed page based on permissions
            final permissions = await TokenStorage.getPermissions();
            final firstRoute = AppRouter.getFirstAllowedRoute(permissions);
            if (context.mounted) {
              context.go(firstRoute);
            }
          } else if (state is LoginError) {
            // Check if message is a translation key (contains dots) or plain text from API
            if (state.message.contains('.') && 
                !state.message.contains(' ') &&
                state.message.split('.').length >= 2) {
              // It's a translation key
              AppSnackbar.showTranslated(
                context: context,
                translationKey: state.message,
                type: SnackbarType.error,
              );
            } else {
              // It's a plain text message from API
              AppSnackbar.showError(
                context,
                state.message,
              );
            }
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: SelectionArea(
              selectionControls: materialTextSelectionControls,
              child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppImages.BG),
                      fit: BoxFit.cover,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 400,
                      color: AppColor.BLACK_0.withOpacity(0.6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                          vertical: 15,
                        ),
                        child: LoginContent(
                          emailController: _emailController,
                          passwordController: _passwordController,
                        ),
                      ),
                    ),
                  ),
                ),
                Builder(
                  builder: (context) {
                    final isRTL = context.locale.languageCode == 'ar';
                    return Positioned(
                      top: 16,
                      left: isRTL ? 16 : null,
                      right: isRTL ? null : 16,
                      child: const LoginLanguageSwitcher(),
                    );
                  },
                ),
              ],
            ),
            ),
          ),
        ),
      ),
    );
  }
}
