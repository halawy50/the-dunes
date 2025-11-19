import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class BaseTableStatusCell extends StatelessWidget {
  const BaseTableStatusCell({
    super.key,
    required this.status,
    required this.color,
    this.textStyle,
  });

  final String status;
  final Color color;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: textStyle ??
            const TextStyle(fontSize: 12, color: AppColor.WHITE),
      ),
    );
  }
}


