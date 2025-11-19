import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/select_type_text_field.dart';
import 'package:the_dunes/features/login/persentation/cubit/login_cubit.dart';
import 'package:the_dunes/features/login/persentation/widgets/login_input_text.dart';

class LoginFormFields extends StatefulWidget {
  const LoginFormFields({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  State<LoginFormFields> createState() => _LoginFormFieldsState();
}

class _LoginFormFieldsState extends State<LoginFormFields> {
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final isLoading = state is LoginLoading;
        return AutofillGroup(
          child: Column(
            children: [
              LoginInputText(
                controller: widget.emailController,
                selectTypeTextField: SelectTypeTextField.EMAIL,
                headerHintKey: 'login.email',
                hintKey: 'login.input_email',
                isRequired: true,
                focusNode: _emailFocusNode,
                onSubmitted: () {
                  _passwordFocusNode.requestFocus();
                },
              ),
              const SizedBox(height: 15),
              LoginInputText(
                controller: widget.passwordController,
                selectTypeTextField: SelectTypeTextField.PASSWORD,
                headerHintKey: 'login.password',
                hintKey: 'login.input_password',
                isRequired: true,
                focusNode: _passwordFocusNode,
                onSubmitted: () {
                  if (!isLoading) {
                    context.read<LoginCubit>().login(
                      widget.emailController.text.trim(),
                      widget.passwordController.text.trim(),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

