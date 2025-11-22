import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'base_table_column.dart';
import 'base_table_widget_v2_add_button_row.dart';

class BaseTableWidgetV2SubRowsBuilder {
  static List<DataRow2> buildSubRows<T>({
    required T item,
    required int index,
    required List<dynamic> subRows,
    required List<BaseTableColumn<dynamic>> Function(T item, int rowIndex) subRowColumns,
    required List<BaseTableColumn<T>> columns,
    required bool showCheckbox,
    required void Function(T item, int rowIndex)? onAddSubRow,
    required String? Function(T item, int rowIndex)? subRowTitle,
  }) {
    final List<DataRow2> rows = [];
    final subColumns = subRowColumns(item, index);
    final mainColumnsCount = columns.length;
    final subColumnsCount = subColumns.length;
    final emptyCellsNeeded = mainColumnsCount - subColumnsCount;
    
    for (int subIndex = 0; subIndex < subRows.length; subIndex++) {
      final subRow = subRows[subIndex];
      rows.add(_buildServiceRow(
        subRow: subRow,
        subIndex: subIndex,
        subColumns: subColumns,
        emptyCellsNeeded: emptyCellsNeeded,
        showCheckbox: showCheckbox,
      ));
    }

    if (onAddSubRow != null) {
      rows.add(BaseTableWidgetV2AddButtonRow.build(
        item: item,
        index: index,
        mainColumnsCount: mainColumnsCount,
        showCheckbox: showCheckbox,
        onAddSubRow: onAddSubRow,
        subRowTitle: subRowTitle,
      ));
    }

    return rows;
  }

  static DataRow2 _buildServiceRow({
    required dynamic subRow,
    required int subIndex,
    required List<BaseTableColumn<dynamic>> subColumns,
    required int emptyCellsNeeded,
    required bool showCheckbox,
  }) {
    return DataRow2(
      color: MaterialStateProperty.all(
        AppColor.GRAY_F6F6F6.withOpacity(0.5),
      ),
      cells: [
        const DataCell(SizedBox(width: 40)),
        if (showCheckbox) const DataCell(SizedBox()),
        ...List.generate(
          emptyCellsNeeded > 0 ? emptyCellsNeeded : 0,
          (_) => const DataCell(SizedBox()),
        ),
        ...subColumns.map((col) => DataCell(
              SizedBox(
                width: col.width,
                child: col.cellBuilder(subRow, subIndex),
              ),
            )),
      ],
    );
  }

}

