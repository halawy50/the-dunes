import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:intl/intl.dart';

class BookingStatisticsWidget extends StatelessWidget {
  final double? totalPrice;
  final int? totalCount;

  const BookingStatisticsWidget({
    super.key,
    this.totalPrice,
    this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPrice == null && totalCount == null) {
      return const SizedBox.shrink();
    }

    final priceFormat = NumberFormat('#,##0.00');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (totalCount != null) ...[
            Icon(
              Icons.receipt_long,
              size: 22,
              color: AppColor.BLACK,
            ),
            const SizedBox(width: 12),
            Text(
              '${'booking.total_count'.tr()}: ',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColor.BLACK,
              ),
            ),
            Text(
              totalCount.toString(),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColor.YELLOW,
              ),
            ),
          ],
          if (totalPrice != null) ...[
            if (totalCount != null) const SizedBox(width: 24),
            Text(
              '${'booking.total_price'.tr()}: ',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColor.BLACK,
              ),
            ),
            Text(
              priceFormat.format(totalPrice),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColor.YELLOW,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'AED',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColor.YELLOW,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

