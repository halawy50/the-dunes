import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class InputTextHeaderWidget extends StatelessWidget {
  final String headerHint;
  final Color headerHintColor;
  final bool isRequired;

  const InputTextHeaderWidget({
    super.key,
    required this.headerHint,
    required this.headerHintColor,
    required this.isRequired,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          headerHint,
          style: TextStyle(color: headerHintColor),
        ),
        if (isRequired) ...[
          const SizedBox(width: 5),
          Text(
            "*",
            style: TextStyle(color: AppColor.RED),
          ),
        ],
      ],
    );
  }
}

