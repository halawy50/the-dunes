import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class ReceiptVoucherItem extends StatelessWidget {
  final String id;
  final String? date;
  final String? amount;
  final String? type;
  final VoidCallback? onTap;

  const ReceiptVoucherItem({
    super.key,
    required this.id,
    this.date,
    this.amount,
    this.type,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColor.YELLOW.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.receipt,
            color: AppColor.YELLOW,
          ),
        ),
        title: Text(
          id,
          style: const TextStyle(
            color: AppColor.BLACK,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: date != null
            ? Text(
                date!,
                style: const TextStyle(
                  color: AppColor.GRAY_HULF,
                ),
              )
            : null,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (amount != null)
              Text(
                amount!,
                style: const TextStyle(
                  color: AppColor.YELLOW,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (type != null)
              Text(
                type!,
                style: const TextStyle(
                  color: AppColor.GRAY_HULF,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
