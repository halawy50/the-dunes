
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/utils/constants/assets/images.dart';
import 'package:the_dunes/core/utils/constants/select_type_text_field.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/app_router/app_router.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/features/login/persentation/cubit/login_cubit.dart';

import '../widgets/login_button.dart';
import '../widgets/login_input_text.dart';

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
      create: (context) => sl<LoginCubit>(),
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
            AppSnackbar.showTranslated(
              context: context,
              translationKey: state.message,
              type: SnackbarType.error,
            );
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Container(
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset(
                              AppImages.LOGO_WHITE,
                              width: 60,
                              height: 60,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'login.get_started'.tr(),
                          style: TextStyle(
                            color: AppColor.WHITE,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'login.login_description'.tr(),
                          style: TextStyle(
                            color: AppColor.WHITE,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 20),
                        LoginInputText(
                          controller: _emailController,
                          selectTypeTextField: SelectTypeTextField.EMAIL,
                          headerHintKey: 'login.email',
                          hintKey: 'login.input_email',
                          isRequired: true,
                        ),
                        SizedBox(height: 15),
                        LoginInputText(
                          controller: _passwordController,
                          selectTypeTextField: SelectTypeTextField.PASSWORD,
                          headerHintKey: 'login.password',
                          hintKey: 'login.input_password',
                          isRequired: true,
                        ),
                        SizedBox(height: 20),
                        BlocBuilder<LoginCubit, LoginState>(
                          builder: (context, state) {
                            final isLoading = state is LoginLoading;
                            return LoginButton(
                              textKey: 'login.login_button',
                              isLoading: isLoading,
                              onPressed: () {
                                context.read<LoginCubit>().login(
                                      _emailController.text.trim(),
                                      _passwordController.text.trim(),
                                    );
                              },
                            );
                          },
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
