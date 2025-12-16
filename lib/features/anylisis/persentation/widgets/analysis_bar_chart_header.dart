import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/anylisis/domain/entities/bookings_by_agency_entity.dart';
import 'package:the_dunes/features/anylisis/persentation/cubit/analysis_cubit.dart';
import 'package:the_dunes/features/anylisis/persentation/widgets/analysis_custom_date_range_dialog.dart';
import 'package:the_dunes/features/anylisis/persentation/widgets/analysis_date_range_helper.dart';
import 'package:the_dunes/features/anylisis/persentation/widgets/analysis_date_range_option.dart';

class AnalysisBarChartHeader extends StatefulWidget {
  final BookingsByAgencyEntity bookingsByAgency;

  const AnalysisBarChartHeader({
    super.key,
    required this.bookingsByAgency,
  });

  @override
  State<AnalysisBarChartHeader> createState() => _AnalysisBarChartHeaderState();
}

class _AnalysisBarChartHeaderState extends State<AnalysisBarChartHeader> {
  AnalysisDateRangeOption _selectedOption = AnalysisDateRangeOption.thisYear;

  void _handleDateRangeChange(AnalysisDateRangeOption? option) {
    if (option == null) return;
    setState(() {
      _selectedOption = option;
    });

    if (option == AnalysisDateRangeOption.custom) {
      AnalysisCustomDateRangeDialog.show(context);
    } else {
      final dateRange = AnalysisDateRangeHelper.getDateRange(option);
      context.read<AnalysisCubit>().loadAnalysisData(
        startDate: dateRange['startDate'],
        endDate: dateRange['endDate'],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'analysis.total_bookings_with_agency'.tr(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              NumberFormat('#,##0').format(widget.bookingsByAgency.totalBookings),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColor.YELLOW,
              ),
            ),
          ],
        ),
        DropdownButton<AnalysisDateRangeOption>(
          value: _selectedOption,
          items: AnalysisDateRangeOption.values.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option.getTranslationKey().tr()),
            );
          }).toList(),
          onChanged: _handleDateRangeChange,
        ),
      ],
    );
  }
}

