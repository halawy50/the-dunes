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
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            text ?? placeholder,
            style: style ??
                TextStyle(
                  fontSize: 13,
                  color: text == null || text!.isEmpty ? AppColor.GRAY_HULF : AppColor.BLACK_0,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

