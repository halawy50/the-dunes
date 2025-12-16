import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_config.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_widget.dart';
import 'package:the_dunes/features/booking/data/models/booking_model.dart';
import 'package:the_dunes/features/booking/data/models/booking_service_model.dart';
import 'package:the_dunes/core/widgets/base_table/booking/booking_service_table_columns.dart';

class BookingServicesDialog extends StatelessWidget {
  final BookingModel booking;

  const BookingServicesDialog({
    super.key,
    required this.booking,
  });

  static Future<void> show(BuildContext context, BookingModel booking) {
    return showDialog(
      context: context,
      builder: (context) => BookingServicesDialog(booking: booking),
    );
  }

  @override
  Widget build(BuildContext context) {
    final columns = BookingServiceTableColumns.buildColumns();

    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 1200, maxHeight: 600),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'booking.services_dialog_title'.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: booking.services.isEmpty
                  ? Center(
                      child: Text(
                        'booking.no_services'.tr(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColor.GRAY_HULF,
                        ),
                      ),
                    )
                  : BaseTableWidget<BookingServiceModel>(
                      columns: columns,
                      data: booking.services,
                      config: BaseTableConfig.defaultConfig,
                    ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('common.cancel'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

