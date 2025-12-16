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
      height: 35,
      width: double.infinity,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
          child: Text(
            text ?? placeholder,
            style: style ??
                TextStyle(
                  fontSize: 11,
                  color: text == null || text!.isEmpty ? AppColor.GRAY_HULF : AppColor.BLACK_0,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }
}

