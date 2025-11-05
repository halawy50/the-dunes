import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/widgets/buttons_wedgits/app_button.dart';

class LoginButton extends StatelessWidget {
  final String textKey;
  final VoidCallback? onPressed;
  final bool isLoading;

  const LoginButton({
    super.key,
    required this.textKey,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: textKey.tr(),
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }
}
