import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/employees/domain/entities/commission_entity.dart';

class EmployeeCommissionSelectionBar extends StatelessWidget {
  final List<CommissionEntity> selectedCommissions;
  final List<CommissionEntity> allCommissions;
  final VoidCallback onPaySelected;
  final VoidCallback? onSelectAllPending;

  const EmployeeCommissionSelectionBar({
    super.key,
    required this.selectedCommissions,
    required this.allCommissions,
    required this.onPaySelected,
    this.onSelectAllPending,
  });

  @override
  Widget build(BuildContext context) {
    final pendingCommissions = allCommissions.where((c) => c.status == 'PENDING').toList();
    final selectedPending = selectedCommissions.where((c) => c.status == 'PENDING').toList();
    final totalSelectedAmount = selectedPending.fold<double>(0.0, (sum, c) => sum + c.amount);

    if (selectedCommissions.isEmpty) {
      if (pendingCommissions.isEmpty) {
        return const SizedBox.shrink();
      }
      return Container(
        width: double.infinity,
        color: AppColor.WHITE,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Row(
          children: [
            Text(
              'employees.pending_commissions_count'.tr(
                namedArgs: {'count': pendingCommissions.length.toString()},
              ),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            if (onSelectAllPending != null)
              TextButton(
                onPressed: onSelectAllPending,
                child: Text('employees.select_all_pending'.tr()),
              ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      color: AppColor.WHITE,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'employees.selected_commissions'.tr(
                  namedArgs: {'count': selectedCommissions.length.toString()},
                ),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              if (selectedPending.isNotEmpty)
                Text(
                  'employees.selected_pending_count'.tr(
                    namedArgs: {
                      'count': selectedPending.length.toString(),
                      'amount': totalSelectedAmount.toStringAsFixed(2),
                    },
                  ),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: onPaySelected,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.YELLOW,
            ),
            child: Text('employees.pay_selected'.tr()),
          ),
        ],
      ),
    );
  }
}

