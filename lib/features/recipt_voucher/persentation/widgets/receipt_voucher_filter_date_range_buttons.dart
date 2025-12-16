import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

enum DateRangeOption { today, thisMonth, lastMonth, lastYear, custom }

class ReceiptVoucherFilterDateRangeButtons extends StatelessWidget {
  final DateRangeOption selectedOption;
  final Function(DateRangeOption) onOptionSelected;

  const ReceiptVoucherFilterDateRangeButtons({
    super.key,
    required this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildButton(
          context,
          'receipt_voucher.today'.tr(),
          DateRangeOption.today,
        ),
        _buildButton(
          context,
          'receipt_voucher.this_month'.tr(),
          DateRangeOption.thisMonth,
        ),
        _buildButton(
          context,
          'receipt_voucher.last_month'.tr(),
          DateRangeOption.lastMonth,
        ),
        _buildButton(
          context,
          'receipt_voucher.last_year'.tr(),
          DateRangeOption.lastYear,
        ),
        _buildButton(
          context,
          'receipt_voucher.custom'.tr(),
          DateRangeOption.custom,
        ),
      ],
    );
  }

  Widget _buildButton(
    BuildContext context,
    String text,
    DateRangeOption option,
  ) {
    final isSelected = selectedOption == option;
    return GestureDetector(
      onTap: () => onOptionSelected(option),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.YELLOW : AppColor.GRAY_F6F6F6,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColor.YELLOW : AppColor.GRAY_D8D8D8,
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? AppColor.WHITE : AppColor.BLACK,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

