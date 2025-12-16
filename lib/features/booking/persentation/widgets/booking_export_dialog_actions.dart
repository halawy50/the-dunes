import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/file_download_helper.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:the_dunes/features/booking/persentation/widgets/booking_filter_date_range_helper.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';

class BookingExportDialogActions extends StatelessWidget {
  final bool isExporting;
  final int? agentId;
  final String? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final VoidCallback onCancel;
  final VoidCallback onExport;

  const BookingExportDialogActions({
    super.key,
    required this.isExporting,
    required this.agentId,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.onCancel,
    required this.onExport,
  });

  static Future<void> handleExport({
    required BuildContext context,
    required int agentId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final dataSource = di<BookingRemoteDataSource>();
      String? formattedStartDate;
      String? formattedEndDate;

      if (startDate != null && endDate != null) {
        formattedStartDate =
            BookingFilterDateRangeHelper.formatDate(startDate);
        formattedEndDate = BookingFilterDateRangeHelper.formatDate(endDate);
      }

      final downloadUrl = await dataSource.exportBookingsToExcel(
        agentId: agentId,
        startDate: formattedStartDate,
        endDate: formattedEndDate,
        status: status,
      );

      await FileDownloadHelper.downloadFile(downloadUrl);
      if (context.mounted) {
        AppSnackbar.showSuccess(
          context,
          'booking.export_success'.tr(),
        );
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackbar.showError(
          context,
          'booking.export_error'.tr(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: isExporting ? null : onCancel,
          child: Text('common.cancel'.tr()),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: isExporting ? null : onExport,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.YELLOW,
            foregroundColor: AppColor.WHITE,
          ),
          child: isExporting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.WHITE),
                  ),
                )
              : Text('booking.export'.tr()),
        ),
      ],
    );
  }
}

