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
    this.onClearFilter,
    this.onRefresh,
    this.hasActiveFilter = false,
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
  final VoidCallback? onClearFilter;
  final VoidCallback? onRefresh;
  final bool hasActiveFilter;
  final String? addButtonText;
  final String? downloadButtonText;
  final String? invoiceButtonText;
  final String? searchHint;
  final String? filterButtonText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 300,
                  child: TextField(
                    onChanged: onSearch,
                    decoration: InputDecoration(
                      hintText: searchHint ?? 'common.search'.tr(),
                      prefixIcon: const Icon(Icons.search, size: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColor.GRAY_D8D8D8,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                  if (onFilter != null) ...[
                    const SizedBox(width: 12),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        OutlinedButton.icon(
                          onPressed: onFilter,
                          icon: const Icon(Icons.filter_list, size: 14),
                          label: Text(
                            filterButtonText ?? 'common.filter'.tr(),
                            style: const TextStyle(fontSize: 11),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            side: BorderSide(
                              color: hasActiveFilter
                                  ? AppColor.YELLOW
                                  : AppColor.GRAY_D8D8D8,
                              width: hasActiveFilter ? 2 : 1,
                            ),
                            backgroundColor: hasActiveFilter
                                ? AppColor.YELLOW.withOpacity(0.1)
                                : null,
                          ),
                        ),
                        if (hasActiveFilter && onClearFilter != null)
                          Positioned(
                            right: -8,
                            top: -8,
                            child: Material(
                              color: AppColor.YELLOW,
                              shape: const CircleBorder(),
                              child: InkWell(
                                onTap: onClearFilter,
                                customBorder: const CircleBorder(),
                                child: const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Icon(
                                    Icons.close,
                                    size: 14,
                                    color: AppColor.WHITE,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onAdd != null) ...[
                  ElevatedButton.icon(
                    onPressed: onAdd,
                    icon: const Icon(Icons.add, size: 14),
                    label: Text(
                      addButtonText ?? 'common.add'.tr(),
                      style: const TextStyle(fontSize: 11),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.YELLOW,
                      foregroundColor: AppColor.WHITE,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
                if (onDownload != null) ...[
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: onDownload,
                    icon: const Icon(Icons.download, size: 14),
                    label: Text(
                      downloadButtonText ?? 'common.download'.tr(),
                      style: const TextStyle(fontSize: 11),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: AppColor.WHITE,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
                if (onInvoice != null) ...[
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: onInvoice,
                    icon: const Icon(Icons.receipt, size: 14),
                    label: Text(
                      invoiceButtonText ?? 'common.invoice'.tr(),
                      style: const TextStyle(fontSize: 11),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: AppColor.WHITE,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
