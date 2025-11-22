import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'base_table_column.dart';
import 'base_table_widget_v2_sub_rows_builder.dart';

class BaseTableWidgetV2RowsBuilder {
  static List<DataRow2> buildRows<T>({
    required List<T> data,
    required List<BaseTableColumn<T>> columns,
    required Map<int, bool> expandedRows,
    required List<dynamic> Function(T item)? getSubRows,
    required List<BaseTableColumn<dynamic>> Function(T item, int rowIndex)? subRowColumns,
    required void Function(T item, int rowIndex)? onAddSubRow,
    required String? Function(T item, int rowIndex)? subRowTitle,
    required bool showCheckbox,
    required List<T> selectedRows,
    required void Function(T item, bool isSelected)? onRowSelect,
    required void Function(int index) toggleRow,
  }) {
    final List<DataRow2> rows = [];
    
    for (int index = 0; index < data.length; index++) {
      final item = data[index];
      final isSelected = selectedRows.contains(item);
      final subRowsList = getSubRows != null ? getSubRows(item) : <dynamic>[];
      final hasSubRows = getSubRows != null;
      final isExpanded = expandedRows[index] ?? false;

      rows.add(_buildMainRow(
        item: item,
        index: index,
        columns: columns,
        isSelected: isSelected,
        hasSubRows: hasSubRows,
        isExpanded: isExpanded,
        showCheckbox: showCheckbox,
        onRowSelect: onRowSelect,
        toggleRow: toggleRow,
      ));

      if (isExpanded && hasSubRows && subRowColumns != null) {
        rows.addAll(BaseTableWidgetV2SubRowsBuilder.buildSubRows(
          item: item,
          index: index,
          subRows: subRowsList,
          subRowColumns: subRowColumns,
          columns: columns,
          showCheckbox: showCheckbox,
          onAddSubRow: onAddSubRow,
          subRowTitle: subRowTitle,
        ));
      }
    }

    return rows;
  }

  static DataRow2 _buildMainRow<T>({
    required T item,
    required int index,
    required List<BaseTableColumn<T>> columns,
    required bool isSelected,
    required bool hasSubRows,
    required bool isExpanded,
    required bool showCheckbox,
    required void Function(T item, bool isSelected)? onRowSelect,
    required void Function(int index) toggleRow,
  }) {
    return DataRow2(
      selected: isSelected,
      cells: [
        DataCell(
          IconButton(
            icon: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              size: 18,
            ),
            onPressed: hasSubRows ? () => toggleRow(index) : null,
            color: hasSubRows ? AppColor.BLACK : Colors.grey,
          ),
        ),
        if (showCheckbox)
          DataCell(
            Checkbox(
              value: isSelected,
              onChanged: (value) {
                onRowSelect?.call(item, value ?? false);
              },
            ),
          ),
        ...columns.map((col) => DataCell(
              SizedBox(
                width: col.width,
                child: col.cellBuilder(item, index),
              ),
            )),
      ],
    );
  }

}

