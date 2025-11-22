import 'package:data_table_2/data_table_2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class BaseTableWidgetV2AddButtonRow {
  static DataRow2 build<T>({
    required T item,
    required int index,
    required int mainColumnsCount,
    required bool showCheckbox,
    required void Function(T item, int rowIndex) onAddSubRow,
    required String? Function(T item, int rowIndex)? subRowTitle,
  }) {
    return DataRow2(
      color: MaterialStateProperty.all(
        AppColor.GRAY_F6F6F6.withOpacity(0.3),
      ),
      cells: [
        const DataCell(SizedBox(width: 40)),
        if (showCheckbox) const DataCell(SizedBox()),
        ...List.generate(
          mainColumnsCount > 0 ? mainColumnsCount - 1 : 0,
          (_) => const DataCell(SizedBox()),
        ),
        DataCell(
          ElevatedButton.icon(
            onPressed: () => onAddSubRow(item, index),
            icon: const Icon(Icons.add, size: 16),
            label: Text(
              subRowTitle?.call(item, index) ?? 'common.add'.tr(),
              style: const TextStyle(fontSize: 12),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.YELLOW,
              foregroundColor: AppColor.WHITE,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

