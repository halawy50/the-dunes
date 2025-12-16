import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/booking/persentation/widgets/booking_filter_date_range_helper.dart';

class BookingExportDialogDateRangeButtons extends StatelessWidget {
  final DateRangeOption selectedOption;
  final void Function(DateRangeOption) onOptionSelected;

  const BookingExportDialogDateRangeButtons({
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
          'booking.today'.tr(),
          DateRangeOption.today,
        ),
        _buildButton(
          context,
          'booking.this_month'.tr(),
          DateRangeOption.thisMonth,
        ),
        _buildButton(
          context,
          'booking.last_month'.tr(),
          DateRangeOption.lastMonth,
        ),
        _buildButton(
          context,
          'booking.last_year'.tr(),
          DateRangeOption.lastYear,
        ),
        _buildButton(
          context,
          'booking.custom'.tr(),
          DateRangeOption.custom,
        ),
      ],
    );
  }

  Widget _buildButton(
    BuildContext context,
    String label,
    DateRangeOption option,
  ) {
    final isSelected = selectedOption == option;
    return OutlinedButton(
      onPressed: () => onOptionSelected(option),
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? AppColor.YELLOW : AppColor.WHITE,
        foregroundColor: isSelected ? AppColor.WHITE : AppColor.BLACK,
        side: BorderSide(
          color: isSelected ? AppColor.YELLOW : AppColor.GRAY_DARK,
        ),
      ),
      child: Text(label),
    );
  }
}

