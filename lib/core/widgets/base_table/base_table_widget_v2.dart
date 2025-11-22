import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'base_table_column.dart';
import 'base_table_config.dart';
import 'base_table_widget_v2_rows_builder.dart';
import 'base_table_widget_v2_columns_builder.dart';

class BaseTableWidgetV2<T> extends StatefulWidget {
  const BaseTableWidgetV2({
    super.key,
    required this.columns,
    required this.data,
    this.onRowSelect,
    this.selectedRows = const [],
    this.showCheckbox = false,
    this.config = BaseTableConfig.defaultConfig,
    this.getSubRows,
    this.subRowColumns,
    this.onAddSubRow,
    this.subRowTitle,
  });

  final List<BaseTableColumn<T>> columns;
  final List<T> data;
  final void Function(T item, bool isSelected)? onRowSelect;
  final List<T> selectedRows;
  final bool showCheckbox;
  final BaseTableConfig config;
  final List<dynamic> Function(T item)? getSubRows;
  final List<BaseTableColumn<dynamic>> Function(T item, int rowIndex)? subRowColumns;
  final void Function(T item, int rowIndex)? onAddSubRow;
  final String? Function(T item, int rowIndex)? subRowTitle;

  @override
  State<BaseTableWidgetV2<T>> createState() => _BaseTableWidgetV2State<T>();
}

class _BaseTableWidgetV2State<T> extends State<BaseTableWidgetV2<T>> {
  final Map<int, bool> _expandedRows = {};
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _verticalScrollController.jumpTo(0);
    });
  }

  @override
  void dispose() {
    _verticalScrollController.dispose();
    super.dispose();
  }

  void _toggleRow(int index) {
    setState(() {
      _expandedRows[index] = !(_expandedRows[index] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = widget.columns.fold<double>(
          0,
          (sum, col) => sum + (col.width ?? 100.0),
        ) +
            (widget.getSubRows != null ? 40.0 : 0.0) +
            (widget.showCheckbox ? 48.0 : 0.0) +
            24.0;
        
        return Container(
          decoration: BoxDecoration(
            color: widget.config.backgroundColor ?? AppColor.WHITE,
            borderRadius: BorderRadius.circular(widget.config.borderRadius ?? 8),
            border: widget.config.showBorder
                ? Border.all(color: AppColor.GRAY_D8D8D8)
                : null,
          ),
          constraints: BoxConstraints(
            maxHeight: constraints.maxHeight,
            maxWidth: constraints.maxWidth,
          ),
          child: DataTable2(
            headingRowColor: MaterialStateProperty.all(
              widget.config.headerColor ?? AppColor.GRAY_F6F6F6,
            ),
            horizontalMargin: 12,
            columnSpacing: 12,
            minWidth: totalWidth,
            smRatio: 0.5,
            scrollController: _verticalScrollController,
            columns: BaseTableWidgetV2ColumnsBuilder.build(
              columns: widget.columns,
              hasSubRows: widget.getSubRows != null,
              showCheckbox: widget.showCheckbox,
              selectedRows: widget.selectedRows,
              data: widget.data,
              onRowSelect: widget.onRowSelect,
            ),
            rows: _buildRows(),
          ),
        );
      },
    );
  }

  List<DataRow2> _buildRows() {
    return BaseTableWidgetV2RowsBuilder.buildRows(
      data: widget.data,
      columns: widget.columns,
      expandedRows: _expandedRows,
      getSubRows: widget.getSubRows,
      subRowColumns: widget.subRowColumns,
      onAddSubRow: widget.onAddSubRow,
      subRowTitle: widget.subRowTitle,
      showCheckbox: widget.showCheckbox,
      selectedRows: widget.selectedRows,
      onRowSelect: widget.onRowSelect,
      toggleRow: _toggleRow,
    );
  }
}

