import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_config.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_widget.dart';
import 'package:the_dunes/features/pickup_times/presentation/models/pickup_table_item.dart';
import 'package:the_dunes/core/widgets/base_table/pickup_times/pickup_times_service_table_columns.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/pickup_service_entity.dart';

class PickupServicesDialog extends StatelessWidget {
  final PickupTableItem item;

  const PickupServicesDialog({
    super.key,
    required this.item,
  });

  static Future<void> show(BuildContext context, PickupTableItem item) {
    return showDialog(
      context: context,
      builder: (context) => PickupServicesDialog(item: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    final columns = PickupTimesServiceTableColumns.buildColumns();
    final services = item.services;

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
                  'pickup_times.services_dialog_title'.tr(),
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
              child: services.isEmpty
                  ? Center(
                      child: Text(
                        'pickup_times.no_services'.tr(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColor.GRAY_HULF,
                        ),
                      ),
                    )
                  : BaseTableWidget<PickupServiceEntity>(
                      columns: columns,
                      data: services,
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

