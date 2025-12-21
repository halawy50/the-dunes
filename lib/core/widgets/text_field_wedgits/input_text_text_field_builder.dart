import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/utils/constants/select_type_text_field.dart';
import 'package:the_dunes/core/widgets/text_field_wedgits/input_text_decoration_builder.dart';

class InputTextFieldBuilder {
  static Widget buildTextField({
    required SelectTypeTextField selectTypeTextField,
    required String hint,
    required Color hintColor,
    required Color inputColor,
    required TextEditingController textController,
    required FocusNode? focusNode,
    required VoidCallback? onSubmitted,
    required bool isHovered,
    required Function(bool) setHovered,
    required bool obscurePassword,
    required Function() toggleObscurePassword,
    required bool isProcessingSplit,
  }) {
    final isPassword = selectTypeTextField == SelectTypeTextField.PASSWORD;
    final isEmail = selectTypeTextField == SelectTypeTextField.EMAIL;
    return MouseRegion(
      onEnter: (_) => setHovered(true),
      onExit: (_) => setHovered(false),
      child: TextField(
        controller: textController,
        focusNode: focusNode,
        cursorColor: AppColor.WHITE,
        style: TextStyle(color: inputColor),
        keyboardType: _getKeyboardType(selectTypeTextField),
        obscureText: isPassword ? obscurePassword : false,
        autofillHints: isEmail
            ? [AutofillHints.email]
            : isPassword
                ? [AutofillHints.password]
                : null,
        textInputAction: isEmail
            ? TextInputAction.next
            : isPassword
                ? TextInputAction.done
                : TextInputAction.next,
        onSubmitted: (_) => onSubmitted?.call(),
        decoration: InputTextDecorationBuilder.buildDecoration(
          hint: hint,
          hintColor: hintColor,
          isHovered: isHovered,
          isPassword: isPassword,
          obscurePassword: obscurePassword,
          inputColor: inputColor,
          toggleObscurePassword: toggleObscurePassword,
          isProcessingSplit: isProcessingSplit,
        ),
      ),
    );
  }

  static TextInputType _getKeyboardType(SelectTypeTextField selectTypeTextField) {
    switch (selectTypeTextField) {
      case SelectTypeTextField.EMAIL:
        return TextInputType.emailAddress;
      case SelectTypeTextField.NUMBER:
      case SelectTypeTextField.PHONE_NUMBER:
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }
}
