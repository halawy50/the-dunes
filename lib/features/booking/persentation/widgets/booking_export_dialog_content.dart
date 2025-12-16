import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/booking/persentation/widgets/booking_filter_date_range_helper.dart';
import 'package:the_dunes/features/booking/persentation/widgets/booking_export_dialog_fields.dart';
import 'package:the_dunes/features/booking/persentation/widgets/booking_export_dialog_actions.dart';
import 'package:the_dunes/features/booking/persentation/widgets/booking_export_dialog_date_range_buttons.dart';
import 'package:the_dunes/features/booking/persentation/widgets/booking_export_dialog_state.dart';

class BookingExportDialogContent extends StatelessWidget {
  final BookingExportDialogState state;
  final void Function(DateRangeOption) onDateRangeOptionSelected;
  final VoidCallback onCancel;
  final VoidCallback onExport;

  const BookingExportDialogContent({
    super.key,
    required this.state,
    required this.onDateRangeOptionSelected,
    required this.onCancel,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'booking.export_excel'.tr(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          StatefulBuilder(
            builder: (context, setState) => BookingExportDialogFields(
              agentId: state.agentId,
              status: state.status,
              agents: state.agents,
              loadingAgents: state.loadingAgents,
              onAgentIdChanged: (value) {
                state.agentId = value;
                setState(() {});
              },
              onStatusChanged: (value) {
                state.status = value;
                setState(() {});
              },
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'booking.date_range'.tr(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          BookingExportDialogDateRangeButtons(
            selectedOption: state.dateRangeOption,
            onOptionSelected: onDateRangeOptionSelected,
          ),
          if (state.startDate != null && state.endDate != null) ...[
            const SizedBox(height: 12),
            Text(
              '${'booking.time_start'.tr()}: ${BookingFilterDateRangeHelper.formatDate(state.startDate!)}\n${'booking.time_end'.tr()}: ${BookingFilterDateRangeHelper.formatDate(state.endDate!)}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColor.GRAY_DARK,
              ),
            ),
          ],
          const SizedBox(height: 24),
          BookingExportDialogActions(
            isExporting: state.isExporting,
            agentId: state.agentId,
            status: state.status,
            startDate: state.startDate,
            endDate: state.endDate,
            onCancel: onCancel,
            onExport: onExport,
          ),
        ],
      ),
    );
  }
}

