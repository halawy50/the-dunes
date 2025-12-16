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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      constraints: const BoxConstraints(
        minWidth: 60,
        maxWidth: 100,
        minHeight: 20,
        maxHeight: 24,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        status,
        textAlign: TextAlign.center,
        style: textStyle ??
            const TextStyle(fontSize: 10, color: AppColor.WHITE),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}


