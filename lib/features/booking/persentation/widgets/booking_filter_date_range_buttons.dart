import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/booking/persentation/widgets/booking_filter_date_range_helper.dart';

class BookingFilterDateRangeButtons extends StatelessWidget {
  final DateRangeOption selectedOption;
  final Function(DateRangeOption) onOptionSelected;

  const BookingFilterDateRangeButtons({
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
          'booking.today'.tr(),
          DateRangeOption.today,
        ),
        _buildButton(
          'booking.this_month'.tr(),
          DateRangeOption.thisMonth,
        ),
        _buildButton(
          'booking.last_month'.tr(),
          DateRangeOption.lastMonth,
        ),
        _buildButton(
          'booking.last_year'.tr(),
          DateRangeOption.lastYear,
        ),
        _buildButton(
          'booking.custom'.tr(),
          DateRangeOption.custom,
        ),
      ],
    );
  }

  Widget _buildButton(String label, DateRangeOption option) {
    final isSelected = selectedOption == option;
    return OutlinedButton(
      onPressed: () => onOptionSelected(option),
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? AppColor.YELLOW.withOpacity(0.1) : null,
        side: BorderSide(
          color: isSelected ? AppColor.YELLOW : AppColor.GRAY_D8D8D8,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColor.YELLOW : AppColor.BLACK,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

