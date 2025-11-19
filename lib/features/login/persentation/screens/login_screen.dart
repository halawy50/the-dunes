import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/utils/constants/assets/images.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/app_router/app_router.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
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
        listener: (context, state) {
          if (state is LoginSuccess) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: 'login.login_success',
              type: SnackbarType.success,
            );
            // Navigate to navbar screen (analysis page)
            context.go(AppRouter.home);
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
