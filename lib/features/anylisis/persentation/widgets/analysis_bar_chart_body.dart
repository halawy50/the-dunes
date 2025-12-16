import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/anylisis/domain/entities/bookings_by_agency_entity.dart';

class AnalysisBarChartBody extends StatelessWidget {
  final BookingsByAgencyEntity bookingsByAgency;
  final double maxCount;
  final double chartHeight;
  final double barWidth;

  const AnalysisBarChartBody({
    super.key,
    required this.bookingsByAgency,
    required this.maxCount,
    required this.chartHeight,
    required this.barWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: chartHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: bookingsByAgency.agencies.map((agency) {
          final barHeight = maxCount > 0
              ? (agency.bookingCount / maxCount) * (chartHeight - 60)
              : 0.0;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: barWidth,
                height: barHeight,
                decoration: BoxDecoration(
                  color: AppColor.YELLOW,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
                child: Center(
                  child: Text(
                    agency.bookingCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 80,
                child: Text(
                  agency.agentName,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

