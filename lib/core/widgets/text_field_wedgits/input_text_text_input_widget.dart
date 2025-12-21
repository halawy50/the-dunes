import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class InputTextTextInputWidget extends StatelessWidget {
  final TextEditingController textController;
  final String hint;
  final Color hintColor;
  final Color inputColor;
  final bool isHovered;
  final Function(bool) setHovered;
  final bool isProcessingSplit;

  const InputTextTextInputWidget({
    super.key,
    required this.textController,
    required this.hint,
    required this.hintColor,
    required this.inputColor,
    required this.isHovered,
    required this.setHovered,
    required this.isProcessingSplit,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setHovered(true),
      onExit: (_) => setHovered(false),
      child: TextField(
        controller: textController,
        cursorColor: AppColor.WHITE,
        style: TextStyle(color: inputColor),
        maxLines: null,
        minLines: 5,
        decoration: InputDecoration(
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
          suffixIcon: isProcessingSplit
              ? Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

