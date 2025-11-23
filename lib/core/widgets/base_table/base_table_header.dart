import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class BaseTableHeader extends StatelessWidget {
  const BaseTableHeader({
    super.key,
    this.onAdd,
    this.onDownload,
    this.onInvoice,
    required this.onSearch,
    this.onFilter,
    this.addButtonText,
    this.downloadButtonText,
    this.invoiceButtonText,
    this.searchHint,
    this.filterButtonText,
  });

  final void Function()? onAdd;
  final VoidCallback? onDownload;
  final VoidCallback? onInvoice;
  final void Function(String) onSearch;
  final VoidCallback? onFilter;
  final String? addButtonText;
  final String? downloadButtonText;
  final String? invoiceButtonText;
  final String? searchHint;
  final String? filterButtonText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            SizedBox(
              width: 300,
              child: TextField(
                onChanged: onSearch,
                decoration: InputDecoration(
                  hintText: searchHint ?? 'common.search'.tr(),
                  prefixIcon: const Icon(Icons.search, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColor.GRAY_D8D8D8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            if (onFilter != null) ...[
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: onFilter,
                icon: const Icon(Icons.filter_list, size: 16),
                label: Text(
                  filterButtonText ?? 'common.filter'.tr(),
                  style: const TextStyle(fontSize: 13),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
              ),
            ],
            if (onAdd != null) ...[
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add, size: 16),
                label: Text(
                  addButtonText ?? 'common.add'.tr(),
                  style: const TextStyle(fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.YELLOW,
                  foregroundColor: AppColor.WHITE,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
              ),
            ],
            if (onDownload != null) ...[
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: onDownload,
                icon: const Icon(Icons.download, size: 16),
                label: Text(
                  downloadButtonText ?? 'common.download'.tr(),
                  style: const TextStyle(fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: AppColor.WHITE,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
              ),
            ],
            if (onInvoice != null) ...[
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: onInvoice,
                icon: const Icon(Icons.receipt, size: 16),
                label: Text(
                  invoiceButtonText ?? 'common.invoice'.tr(),
                  style: const TextStyle(fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: AppColor.WHITE,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
              ),
            ],
          ],
        );
        },
      ),
    );
  }
}

