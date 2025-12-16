import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/booking/data/datasources/booking_options_remote_data_source.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/features/booking/persentation/widgets/booking_export_dialog_state.dart';
import 'package:the_dunes/features/booking/persentation/widgets/booking_export_dialog_logic.dart';
import 'package:the_dunes/features/booking/persentation/widgets/booking_export_dialog_content.dart';
import 'package:the_dunes/features/booking/persentation/widgets/booking_export_dialog_actions.dart';
import 'package:the_dunes/features/booking/persentation/widgets/booking_filter_date_range_helper.dart';
import 'package:easy_localization/easy_localization.dart';

class BookingExportDialog extends StatefulWidget {
  const BookingExportDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const BookingExportDialog(),
    );
  }

  @override
  State<BookingExportDialog> createState() => _BookingExportDialogState();
}

class _BookingExportDialogState extends State<BookingExportDialog> {
  late BookingExportDialogState _state;

  @override
  void initState() {
    super.initState();
    _state = BookingExportDialogState();
    _state.setTodayRange();
    _loadAgents();
  }

  Future<void> _loadAgents() async {
    try {
      final dataSource = di<BookingOptionsRemoteDataSource>();
      final agents = await dataSource.getAllAgents();
      setState(() {
        _state.agents = agents;
        _state.loadingAgents = false;
      });
    } catch (e) {
      setState(() {
        _state.loadingAgents = false;
      });
    }
  }

  void _handleDateRangeOption(DateRangeOption option) {
    BookingExportDialogLogic.handleDateRangeOption(
      context,
      _state,
      option,
      () => setState(() {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColor.WHITE,
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: BookingExportDialogContent(
          state: _state,
          onDateRangeOptionSelected: _handleDateRangeOption,
          onCancel: () => Navigator.of(context).pop(),
          onExport: () async {
            if (_state.agentId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('booking.agent_required'.tr()),
                ),
              );
              return;
            }
            setState(() => _state.isExporting = true);
            try {
              await BookingExportDialogActions.handleExport(
                context: context,
                agentId: _state.agentId!,
                status: _state.status,
                startDate: _state.startDate,
                endDate: _state.endDate,
              );
              if (mounted) {
                Navigator.of(context).pop();
              }
            } finally {
              if (mounted) {
                setState(() => _state.isExporting = false);
              }
            }
          },
        ),
      ),
    );
  }
}

