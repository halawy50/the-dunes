import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

enum CommissionFilterStatus {
  all,
  pending,
  paid,
}

class EmployeeCommissionFilter extends StatelessWidget {
  final CommissionFilterStatus selectedFilter;
  final ValueChanged<CommissionFilterStatus> onFilterChanged;

  const EmployeeCommissionFilter({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColor.WHITE,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Row(
        children: [
          Text(
            'employees.filter_by_status'.tr(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              children: [
                _buildFilterChip(
                  label: 'employees.all'.tr(),
                  isSelected: selectedFilter == CommissionFilterStatus.all,
                  onTap: () => onFilterChanged(CommissionFilterStatus.all),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'employees.pending'.tr(),
                  isSelected: selectedFilter == CommissionFilterStatus.pending,
                  onTap: () => onFilterChanged(CommissionFilterStatus.pending),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'employees.paid'.tr(),
                  isSelected: selectedFilter == CommissionFilterStatus.paid,
                  onTap: () => onFilterChanged(CommissionFilterStatus.paid),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.YELLOW : AppColor.WHITE,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColor.YELLOW : AppColor.GRAY_HULF,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? AppColor.BLACK : AppColor.GRAY_HULF,
          ),
        ),
      ),
    );
  }
}

