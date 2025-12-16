import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/anylisis/domain/entities/bookings_by_agency_entity.dart';
import 'package:the_dunes/features/anylisis/domain/entities/dashboard_summary_entity.dart';
import 'package:the_dunes/features/anylisis/domain/entities/employee_with_vouchers_entity.dart';
import 'package:the_dunes/features/anylisis/persentation/widgets/analysis_bar_chart.dart';
import 'package:the_dunes/features/anylisis/persentation/widgets/analysis_dashboard_cards.dart';
import 'package:the_dunes/features/anylisis/persentation/widgets/analysis_employees_table.dart';

class AnalysisContentBuilder extends StatelessWidget {
  final DashboardSummaryEntity dashboardSummary;
  final BookingsByAgencyEntity bookingsByAgency;
  final EmployeesWithVouchersEntity employeesWithVouchers;

  const AnalysisContentBuilder({
    super.key,
    required this.dashboardSummary,
    required this.bookingsByAgency,
    required this.employeesWithVouchers,
  });

  @override
  Widget build(BuildContext context) {
    final priceFormat = NumberFormat('#,##0.00');

    return Container(
      color: AppColor.WHITE,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnalysisDashboardCards(
              summary: dashboardSummary,
              priceFormat: priceFormat,
            ),
            AnalysisBarChart(bookingsByAgency: bookingsByAgency),
            AnalysisEmployeesTable(
              employeesWithVouchers: employeesWithVouchers,
            ),
          ],
        ),
      ),
    );
  }
}

