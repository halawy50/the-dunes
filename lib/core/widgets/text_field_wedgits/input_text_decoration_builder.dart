import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class InputTextDecorationBuilder {
  static InputDecoration buildDecoration({
    required String hint,
    required Color hintColor,
    required bool isHovered,
    required bool isPassword,
    required bool obscurePassword,
    required Color inputColor,
    required Function() toggleObscurePassword,
    required bool isProcessingSplit,
  }) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: isHovered ? AppColor.GRAY_WHITE : Colors.grey,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: isHovered ? AppColor.GRAY_WHITE : Colors.grey,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.WHITE),
        borderRadius: BorderRadius.circular(5),
      ),
      hintText: hint,
      hintStyle: TextStyle(
        color: hintColor,
        fontWeight: FontWeight.normal,
        fontSize: 14,
      ),
      suffixIcon: _buildSuffixIcon(
        isPassword: isPassword,
        obscurePassword: obscurePassword,
        inputColor: inputColor,
        toggleObscurePassword: toggleObscurePassword,
        isProcessingSplit: isProcessingSplit,
      ),
    );
  }

  static Widget? _buildSuffixIcon({
    required bool isPassword,
    required bool obscurePassword,
    required Color inputColor,
    required Function() toggleObscurePassword,
    required bool isProcessingSplit,
  }) {
    if (isPassword) {
      return IconButton(
        icon: Icon(
          obscurePassword ? Icons.visibility_off : Icons.visibility,
          color: inputColor,
          size: 20,
        ),
        onPressed: toggleObscurePassword,
      );
    }
    if (isProcessingSplit) {
      return Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    return null;
  }
}

