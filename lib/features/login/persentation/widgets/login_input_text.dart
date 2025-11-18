import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/utils/constants/select_type_text_field.dart';
import 'package:the_dunes/core/widgets/text_field_wedgits/input_text.dart';

class LoginInputText extends StatelessWidget {
  final SelectTypeTextField selectTypeTextField;
  final String headerHintKey;
  final String hintKey;
  final TextEditingController? controller;
  final bool isRequired;
  final Function(String)? onTextChanged;
  final VoidCallback? onSubmitted;
  final FocusNode? focusNode;

  const LoginInputText({
    super.key,
    required this.selectTypeTextField,
    required this.headerHintKey,
    required this.hintKey,
    this.controller,
    this.isRequired = false,
    this.onTextChanged,
    this.onSubmitted,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return InputText(
      controller: controller,
      selectTypeTextField: selectTypeTextField,
      headerHint: headerHintKey.tr(),
      headerHintColor: AppColor.WHITE,
      hint: hintKey.tr(),
      hintColor: AppColor.GRAY_D8D8D8,
      inputColor: AppColor.WHITE,
      isRequired: isRequired,
      onTextChanged: onTextChanged,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
    );
  }
}
