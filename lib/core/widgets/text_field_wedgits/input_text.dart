import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/utils/constants/select_type_text_field.dart';
import 'package:the_dunes/core/utils/model/text_field_model.dart';
import 'package:the_dunes/core/widgets/text_field_wedgits/input_text_state.dart';

class InputText extends StatelessWidget {
  final SelectTypeTextField selectTypeTextField;
  final String headerHint;
  final Color headerHintColor;
  final String hint;
  final Color hintColor;
  final List<TextFieldModel> listOfTextFieldModel;
  final bool isRequired;
  final Color inputColor;
  final TextEditingController? controller;
  final Function(String)? onTextChanged;
  final Function(List<String>)? onFilesSplit;
  final VoidCallback? onSubmitted;
  final FocusNode? focusNode;

  const InputText({
    super.key,
    required this.selectTypeTextField,
    required this.headerHint,
    this.headerHintColor = AppColor.GRAY_DARK,
    this.hintColor = AppColor.GRAY_HULF,
    required this.hint,
    required this.isRequired,
    this.inputColor = AppColor.BLACK,
    this.listOfTextFieldModel = const [],
    this.controller,
    this.onTextChanged,
    this.onFilesSplit,
    this.onSubmitted,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return InputTextState(
      selectTypeTextField: selectTypeTextField,
      headerHint: headerHint,
      headerHintColor: headerHintColor,
      hint: hint,
      hintColor: hintColor,
      isRequired: isRequired,
      inputColor: inputColor,
      listOfTextFieldModel: listOfTextFieldModel,
      controller: controller,
      onTextChanged: onTextChanged,
      onFilesSplit: onFilesSplit,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
    );
  }
}
