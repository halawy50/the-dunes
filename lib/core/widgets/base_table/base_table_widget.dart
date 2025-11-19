import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'base_table_column.dart';
import 'base_table_config.dart';

class BaseTableWidget<T> extends StatefulWidget {
  const BaseTableWidget({
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
  State<BaseTableWidget<T>> createState() => _BaseTableWidgetState<T>();
}

class _BaseTableWidgetState<T> extends State<BaseTableWidget<T>> {
  final Map<int, bool> _expandedRows = {};
  final ScrollController _horizontalScrollController = ScrollController();
  bool _showLeftArrow = false;
  bool _showRightArrow = true;

  @override
  void initState() {
    super.initState();
    _horizontalScrollController.addListener(_updateScrollIndicators);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateScrollIndicators();
    });
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void _updateScrollIndicators() {
    if (!_horizontalScrollController.hasClients) return;
    final position = _horizontalScrollController.position;
    setState(() {
      _showLeftArrow = position.pixels > 0;
      _showRightArrow = position.pixels < position.maxScrollExtent;
    });
  }

  void _scrollLeft() {
    _horizontalScrollController.animateTo(
      _horizontalScrollController.offset - 300,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _scrollRight() {
    _horizontalScrollController.animateTo(
      _horizontalScrollController.offset + 300,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _toggleRow(int index) {
    setState(() {
      _expandedRows[index] = !(_expandedRows[index] ?? false);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: widget.config.backgroundColor ?? AppColor.WHITE,
            borderRadius: BorderRadius.circular(widget.config.borderRadius ?? 8),
            border: widget.config.showBorder
                ? Border.all(color: AppColor.GRAY_D8D8D8)
                : null,
          ),
          child: Scrollbar(
            controller: _horizontalScrollController,
            thumbVisibility: true,
            thickness: 8,
            radius: const Radius.circular(4),
            child: SingleChildScrollView(
              controller: _horizontalScrollController,
              scrollDirection: Axis.horizontal,
              child: Scrollbar(
                thickness: 8,
                radius: const Radius.circular(4),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(
                      widget.config.headerColor ?? AppColor.GRAY_F6F6F6,
                    ),
                    dataRowMinHeight: widget.config.rowMinHeight ?? 40,
                    dataRowMaxHeight: widget.config.rowMaxHeight ?? 200,
                    columns: [
                      if (widget.getSubRows != null)
                        const DataColumn(label: SizedBox(width: 40)),
                      if (widget.showCheckbox)
                        DataColumn(
                          label: Checkbox(
                            value: widget.selectedRows.length == widget.data.length &&
                                widget.data.isNotEmpty,
                            onChanged: (value) {
                              if (widget.onRowSelect != null) {
                                for (var item in widget.data) {
                                  widget.onRowSelect!(item, value ?? false);
                                }
                              }
                            },
                          ),
                        ),
                      ...widget.columns.map((col) => DataColumn(
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
                          )),
                    ],
                    rows: _buildRows(),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_showLeftArrow)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColor.WHITE.withOpacity(0.9),
                    AppColor.WHITE.withOpacity(0.0),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.chevron_left, size: 24),
                  color: AppColor.BLACK,
                  onPressed: _scrollLeft,
                ),
              ),
            ),
          ),
        if (_showRightArrow)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColor.WHITE.withOpacity(0.0),
                    AppColor.WHITE.withOpacity(0.9),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.chevron_right, size: 24),
                  color: AppColor.BLACK,
                  onPressed: _scrollRight,
                ),
              ),
            ),
          ),
      ],
    );
  }

  List<DataRow> _buildRows() {
    final List<DataRow> rows = [];
    
    for (int index = 0; index < widget.data.length; index++) {
      final item = widget.data[index];
      final isSelected = widget.selectedRows.contains(item);
      final subRowsList = widget.getSubRows?.call(item) ?? [];
      final hasSubRows = widget.getSubRows != null;
      final isExpanded = _expandedRows[index] ?? false;

      rows.add(DataRow(
        selected: isSelected,
        cells: [
          if (widget.getSubRows != null)
            DataCell(
              IconButton(
                icon: Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 18,
                ),
                onPressed: hasSubRows ? () => _toggleRow(index) : null,
                color: hasSubRows ? AppColor.BLACK : Colors.grey,
              ),
            ),
          if (widget.showCheckbox)
            DataCell(
              Checkbox(
                value: isSelected,
                onChanged: (value) {
                  widget.onRowSelect?.call(item, value ?? false);
                },
              ),
            ),
          ...widget.columns.map((col) => DataCell(
                SizedBox(
                  width: col.width,
                  child: col.cellBuilder(item, index),
                ),
              )),
        ],
      ));

      if (isExpanded && hasSubRows && widget.subRowColumns != null) {
        final subRows = subRowsList;
        final subColumns = widget.subRowColumns!(item, index);
        
        for (int subIndex = 0; subIndex < subRows.length; subIndex++) {
          final subRow = subRows[subIndex];
          rows.add(DataRow(
            color: MaterialStateProperty.all(
              AppColor.GRAY_F6F6F6.withOpacity(0.5),
            ),
            cells: [
              if (widget.getSubRows != null)
                const DataCell(SizedBox(width: 40)),
              if (widget.showCheckbox) const DataCell(SizedBox()),
              ...subColumns.map((col) => DataCell(
                    SizedBox(
                      width: col.width,
                      child: col.cellBuilder(subRow, subIndex),
                    ),
                  )),
            ],
          ));
        }

        if (widget.onAddSubRow != null) {
          rows.add(DataRow(
            color: MaterialStateProperty.all(
              AppColor.GRAY_F6F6F6.withOpacity(0.3),
            ),
            cells: [
              if (widget.getSubRows != null)
                const DataCell(SizedBox(width: 40)),
              if (widget.showCheckbox) const DataCell(SizedBox()),
              DataCell(
                ElevatedButton.icon(
                  onPressed: () => widget.onAddSubRow!(item, index),
                  icon: const Icon(Icons.add, size: 16),
                  label: Text(
                    widget.subRowTitle?.call(item, index) ?? 'common.add'.tr(),
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
              ...List.generate(
                subColumns.length - 1,
                (_) => const DataCell(SizedBox()),
              ),
            ],
          ));
        }
      }
    }

    return rows;
  }
}
