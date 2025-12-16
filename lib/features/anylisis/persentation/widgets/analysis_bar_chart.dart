import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/anylisis/domain/entities/bookings_by_agency_entity.dart';
import 'package:the_dunes/features/anylisis/persentation/widgets/analysis_bar_chart_body.dart';
import 'package:the_dunes/features/anylisis/persentation/widgets/analysis_bar_chart_header.dart';

class AnalysisBarChart extends StatelessWidget {
  final BookingsByAgencyEntity bookingsByAgency;

  const AnalysisBarChart({
    super.key,
    required this.bookingsByAgency,
  });

  @override
  Widget build(BuildContext context) {
    final chartHeight = 300.0;
    final barWidth = 40.0;
    final hasData = bookingsByAgency.agencies.isNotEmpty;
    final maxCount = hasData
        ? bookingsByAgency.agencies
            .map((a) => a.bookingCount.toDouble())
            .reduce((a, b) => a > b ? a : b)
        : 0.0;

    return Card(
      color: AppColor.WHITE,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnalysisBarChartHeader(bookingsByAgency: bookingsByAgency),
            const SizedBox(height: 24),
            if (hasData)
              AnalysisBarChartBody(
                bookingsByAgency: bookingsByAgency,
                maxCount: maxCount,
                chartHeight: chartHeight,
                barWidth: barWidth,
              ),
          ],
        ),
      ),
    );
  }
}

