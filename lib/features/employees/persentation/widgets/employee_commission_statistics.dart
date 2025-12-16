import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class EmployeeCommissionStatistics extends StatelessWidget {
  final int voucherCount;
  final double pendingProfits;
  final double profitsPaid;

  const EmployeeCommissionStatistics({
    super.key,
    required this.voucherCount,
    required this.pendingProfits,
    required this.profitsPaid,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'employees.voucher'.tr(),
            value: voucherCount.toString(),
            color: AppColor.GRAY_WHITE,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'employees.pending_profits'.tr(),
            value: '${pendingProfits.toStringAsFixed(2)} AED',
            color: const Color(0xFFFFE5CC),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'employees.profits_paid'.tr(),
            value: '${profitsPaid.toStringAsFixed(2)} AED',
            color: const Color(0xFFE5F5E5),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: AppColor.GRAY_HULF,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColor.BLACK,
            ),
          ),
        ],
      ),
    );
  }
}



