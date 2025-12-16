import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class ReceiptVoucherStatisticsItemWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;
  final bool isBold;

  const ReceiptVoucherStatisticsItemWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.color,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final itemColor = color ?? AppColor.BLACK;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 22,
          color: itemColor,
        ),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColor.BLACK,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 17 : 15,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: itemColor,
          ),
        ),
      ],
    );
  }
}

