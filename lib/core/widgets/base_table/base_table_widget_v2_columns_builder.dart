import 'package:data_table_2/data_table_2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'base_table_column.dart';

class BaseTableWidgetV2ColumnsBuilder {
  static List<DataColumn2> build<T>({
    required List<BaseTableColumn<T>> columns,
    required bool hasSubRows,
    required bool showCheckbox,
    required List<T> selectedRows,
    required List<T> data,
    required void Function(T item, bool isSelected)? onRowSelect,
  }) {
    final List<DataColumn2> result = [];
    
    if (hasSubRows) {
      result.add(const DataColumn2(label: SizedBox(width: 40)));
    }
    
    if (showCheckbox) {
      result.add(DataColumn2(
        label: Checkbox(
          value: selectedRows.length == data.length && data.isNotEmpty,
          onChanged: (value) {
            if (onRowSelect != null) {
              for (var item in data) {
                onRowSelect(item, value ?? false);
              }
            }
          },
        ),
      ));
    }
    
    result.addAll(columns.map((col) => DataColumn2(
          label: SizedBox(
            width: col.width,
            child: Text(
              col.headerKey.tr(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        )));
    
    return result;
  }
}

