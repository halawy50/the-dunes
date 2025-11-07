import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/utils/constants/assets/images.dart';
import 'package:the_dunes/core/utils/constants/select_type_text_field.dart';
import 'package:the_dunes/features/login/persentation/cubit/login_cubit.dart';

import 'login_button.dart';
import 'login_input_text.dart';

class LoginContent extends StatelessWidget {
  const LoginContent({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [Image.asset(AppImages.LOGO_WHITE, width: 60, height: 60)],
        ),
        const SizedBox(height: 10),
        Text(
          'login.get_started'.tr(),
          style: const TextStyle(
            color: AppColor.WHITE,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'login.login_description'.tr(),
          style: const TextStyle(
            color: AppColor.WHITE,
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 20),
        LoginInputText(
          controller: emailController,
          selectTypeTextField: SelectTypeTextField.EMAIL,
          headerHintKey: 'login.email',
          hintKey: 'login.input_email',
          isRequired: true,
        ),
        const SizedBox(height: 15),
        LoginInputText(
          controller: passwordController,
          selectTypeTextField: SelectTypeTextField.PASSWORD,
          headerHintKey: 'login.password',
          hintKey: 'login.input_password',
          isRequired: true,
        ),
        const SizedBox(height: 20),
        BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            final isLoading = state is LoginLoading;
            return LoginButton(
              textKey: 'login.login_button',
              isLoading: isLoading,
              onPressed: () {
                context.read<LoginCubit>().login(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );
              },
            );
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
