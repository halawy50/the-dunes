import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class BaseTableTextCell extends StatelessWidget {
  const BaseTableTextCell({
    super.key,
    required this.text,
    this.style,
    this.placeholder = '-',
  });

  final String? text;
  final TextStyle? style;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? placeholder,
      style: style ??
          TextStyle(
            fontSize: 12,
            color: text == null ? AppColor.GRAY_HULF : AppColor.BLACK_0,
          ),
    );
  }
}

