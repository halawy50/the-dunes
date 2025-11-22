import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/booking/persentation/cubit/new_booking_cubit.dart';
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
    this.canAddSubRow,
    this.subRowTitle,
    this.onAddNewRow,
    this.addNewRowTitle,
    this.onNewRowAdded,
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
  final bool Function(T item, int rowIndex)? canAddSubRow;
  final String? Function(T item, int rowIndex)? subRowTitle;
  final void Function(int rowIndex)? onAddNewRow;
  final String? addNewRowTitle;
  final void Function(int rowIndex)? onNewRowAdded;

  @override
  State<BaseTableWidget<T>> createState() => _BaseTableWidgetState<T>();
}

class _BaseTableWidgetState<T> extends State<BaseTableWidget<T>> {
  final Map<int, bool> _expandedRows = {};
  // Cache for sub-columns to avoid rebuilding them
  final Map<int, List<BaseTableColumn<dynamic>>> _subColumnsCache = {};

  // Check if a field is required (for booking table)
  bool _isRequiredField(String headerKey) {
    const requiredFields = [
      'booking.guest_name',
      'booking.agent_name',
    ];
    return requiredFields.contains(headerKey);
  }

  @override
  void initState() {
    super.initState();
    // Only auto-expand the first row if it's the only row and has sub-rows
    // Don't change existing rows' states
    if (widget.getSubRows != null && widget.data.length == 1) {
      final firstItem = widget.data.first;
      final subRows = widget.getSubRows!(firstItem);
      if (subRows.isNotEmpty) {
        _expandedRows[0] = true;
      }
    }
  }

  @override
  void didUpdateWidget(BaseTableWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Only clear cache if data changed significantly (new row added)
    final rowsAdded = widget.data.length > oldWidget.data.length;
    if (rowsAdded) {
      // Don't clear entire cache, just invalidate for new row
      // Keep cache for existing rows to improve performance
    }
    
    if (widget.getSubRows != null && rowsAdded) {
      // Only handle newly added rows - preserve existing rows' states
      final newRowIndex = widget.data.length - 1;
      if (newRowIndex < widget.data.length) {
        final newRow = widget.data[newRowIndex];
        final subRows = widget.getSubRows!(newRow);
        // Always expand new row if it has sub-rows
        if (subRows.isNotEmpty) {
          // Expand immediately (synchronously) - don't wait for post frame
          if (mounted) {
            setState(() {
              _expandedRows[newRowIndex] = true;
            });
          }
        }
        return; // Exit early - don't check sub-rows for existing rows
      }
    }
    
    // Auto-expand row if a new sub-row was added to it (only check existing rows)
    if (widget.data.length == oldWidget.data.length && widget.data.isNotEmpty) {
      // Use a flag to only check once
      bool foundExpansion = false;
      for (int index = 0; index < widget.data.length && !foundExpansion; index++) {
        if (index < oldWidget.data.length) {
          final currentRow = widget.data[index];
          final oldRow = oldWidget.data[index];
          final currentSubRows = widget.getSubRows!(currentRow);
          final oldSubRows = widget.getSubRows!(oldRow);
          
          // If number of sub-rows increased, auto-expand ONLY that specific row
          if (currentSubRows.length > oldSubRows.length) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _expandedRows[index] = true;
                });
              }
            });
            foundExpansion = true;
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _subColumnsCache.clear();
    super.dispose();
  }

  void _toggleRow(int index) {
    // Optimize: Direct state update for better performance
    if (mounted) {
      setState(() {
        _expandedRows[index] = !(_expandedRows[index] ?? false);
      });
    }
  }

  void _collapseAllRows() {
    if (mounted) {
      setState(() {
        _expandedRows.clear();
      });
    }
  }


  Widget _buildDataTable() {
    // Use a key that includes expanded rows state to force rebuild when collapsing
    final tableKey = ValueKey('table_${_expandedRows.keys.join('_')}_${_expandedRows.values.join('_')}');
    
    return DataTable(
      key: tableKey,
      headingRowColor: MaterialStateProperty.all(
        widget.config.headerColor ?? AppColor.GRAY_F6F6F6,
      ),
      headingRowHeight: 60,
      dataRowMinHeight: widget.config.rowMinHeight ?? 40,
      dataRowMaxHeight: widget.config.rowMinHeight ?? 40,
      horizontalMargin: 12,
      columnSpacing: 8,
      columns: [
        if (widget.getSubRows != null)
          DataColumn(
            label: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Tooltip(
                message: 'common.collapse_all'.tr(),
                child: IconButton(
                  icon: const Icon(Icons.expand_less, size: 20),
                  onPressed: () {
                    _collapseAllRows();
                  },
                  color: AppColor.BLACK,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ),
          ),
        if (widget.showCheckbox)
          DataColumn(
            label: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Checkbox(
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
          ),
        ...widget.columns.map((col) {
          // Check if this is a required field
          final isRequired = _isRequiredField(col.headerKey);
          return DataColumn(
            label: Padding(
              padding: col.headerPadding ?? 
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: SizedBox(
                width: col.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            col.headerKey.tr(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        if (isRequired)
                          const Text(
                            ' *',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
      rows: _buildRows(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          decoration: BoxDecoration(
            color: widget.config.backgroundColor ?? AppColor.WHITE,
            borderRadius: BorderRadius.circular(widget.config.borderRadius ?? 8),
            border: widget.config.showBorder
                ? Border.all(color: AppColor.GRAY_D8D8D8)
                : null,
          ),
          child: _buildDataTable(),
        ),
      ),
    );
  }

  List<DataRow> _buildRows() {
    final List<DataRow> rows = [];
    
    for (int index = 0; index < widget.data.length; index++) {
      final item = widget.data[index];
      final isSelected = widget.selectedRows.contains(item);
      
      // Cache sub-rows list to avoid multiple calls
      List<dynamic>? cachedSubRows;
      if (widget.getSubRows != null) {
        cachedSubRows = widget.getSubRows!(item);
      }
      final subRowsList = cachedSubRows ?? [];
      final hasSubRows = widget.getSubRows != null && subRowsList.isNotEmpty;
      
      // Auto-expand newly added row (last row) if it has sub-rows
      final isLastRow = index == widget.data.length - 1;
      if (isLastRow && hasSubRows && subRowsList.isNotEmpty && !_expandedRows.containsKey(index)) {
        // Mark as expanded immediately for this build cycle
        _expandedRows[index] = true;
      }
      
      final isExpanded = _expandedRows[index] ?? false;

      final mainRowCells = [
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
        ...widget.columns.asMap().entries.map((entry) {
          final colIndex = entry.key;
          final col = entry.value;
          return DataCell(
            RepaintBoundary(
              key: ValueKey('main_cell_${index}_$colIndex'),
              child: SizedBox(
                width: col.width,
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                    top: 8,
                    bottom: 4,
                  ),
                  child: col.cellBuilder(item, index),
                ),
              ),
            ),
          );
        }),
      ];
      
      rows.add(DataRow(
        key: ValueKey('main_row_$index'),
        selected: isSelected,
        cells: mainRowCells,
      ));

      if (isExpanded && hasSubRows && widget.subRowColumns != null) {
        // Wrap sub-rows in RepaintBoundary for better performance
        final subRows = subRowsList;
        
        // Calculate once and reuse
        final mainColumnsCount = (widget.getSubRows != null ? 1 : 0) + 
                                 (widget.showCheckbox ? 1 : 0) + 
                                 widget.columns.length;
        
        // Cache sub-columns to avoid rebuilding them on every toggle
        List<BaseTableColumn<dynamic>> subColumns;
        if (_subColumnsCache.containsKey(index)) {
          subColumns = _subColumnsCache[index]!;
        } else {
          subColumns = widget.subRowColumns!(item, index);
          _subColumnsCache[index] = subColumns;
        }
        final subColumnsCount = subColumns.length;
        final cellsAtStart = (widget.getSubRows != null ? 1 : 0) + (widget.showCheckbox ? 1 : 0);
        final cellsUsed = cellsAtStart + subColumnsCount;
        final emptyCellsNeededAtEnd = mainColumnsCount - cellsUsed;
        
        // Pre-generate empty cells list to avoid repeated List.generate calls
        final emptyCells = List.generate(
          emptyCellsNeededAtEnd > 0 ? emptyCellsNeededAtEnd : 0,
          (_) => const DataCell(SizedBox()),
        );
        
        // Add sub-row header first - align to start (sub-columns after expand/collapse)
        rows.add(DataRow(
          key: ValueKey('sub_header_$index'),
          color: MaterialStateProperty.all(
            AppColor.YELLOW.withOpacity(0.1),
          ),
          cells: [
            if (widget.getSubRows != null)
              const DataCell(SizedBox(width: 40)),
            if (widget.showCheckbox) const DataCell(SizedBox()),
            // Start sub-columns immediately after expand/collapse button
            ...subColumns.map((col) => DataCell(
                  RepaintBoundary(
                    child: SizedBox(
                      width: col.width,
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              col.headerKey.tr(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: Colors.black87,
                                height: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            if (col.headerHint != null)
                              Text(
                                col.headerHint!.tr(),
                                style: const TextStyle(
                                  fontSize: 8,
                                  color: AppColor.GRAY_HULF,
                                  fontWeight: FontWeight.normal,
                                  height: 1.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
            // Add pre-generated empty cells
            ...emptyCells,
          ],
        ));
        
        // Build sub-rows efficiently with keys for better performance
        for (int subIndex = 0; subIndex < subRows.length; subIndex++) {
          final subRow = subRows[subIndex];
          rows.add(DataRow(
            key: ValueKey('sub_row_${index}_$subIndex'),
            color: MaterialStateProperty.all(
              AppColor.GRAY_F6F6F6.withOpacity(0.5),
            ),
            cells: [
              if (widget.getSubRows != null)
                const DataCell(SizedBox(width: 40)),
              if (widget.showCheckbox) const DataCell(SizedBox()),
              // Start sub-columns immediately after expand/collapse button
              ...subColumns.map((col) => DataCell(
                    RepaintBoundary(
                      child: SizedBox(
                        width: col.width,
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: col.cellBuilder(subRow, subIndex),
                        ),
                      ),
                    ),
                  )),
              // Add pre-generated empty cells
              ...emptyCells,
            ],
          ));
        }

        // Check if we can add a sub-row (hide button if all services are selected)
        final canAdd = widget.canAddSubRow?.call(item, index) ?? true;
        
        if (widget.onAddSubRow != null && canAdd) {
          // Calculate empty cells for Add Service button row (takes 1 cell, not 8)
          final addButtonCellsAtStart = (widget.getSubRows != null ? 1 : 0) + (widget.showCheckbox ? 1 : 0);
          final addButtonCellsUsed = addButtonCellsAtStart + 1; // 1 for the button itself
          final addButtonEmptyCellsNeeded = mainColumnsCount - addButtonCellsUsed;
          
          // Pre-generate empty cells for add button
          final addButtonEmptyCells = List.generate(
            addButtonEmptyCellsNeeded > 0 ? addButtonEmptyCellsNeeded : 0,
            (_) => const DataCell(SizedBox()),
          );
          
          rows.add(DataRow(
            color: MaterialStateProperty.all(
              AppColor.GRAY_F6F6F6.withOpacity(0.3),
            ),
            cells: [
              if (widget.getSubRows != null)
                const DataCell(SizedBox(width: 40)),
              if (widget.showCheckbox) const DataCell(SizedBox()),
              // Add Service button aligns to start with sub-columns (larger for mobile touch)
              DataCell(
                SizedBox(
                  width: subColumns.isNotEmpty ? subColumns.first.width : 300,
                  height: 50, // Larger height for easier touch
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Container(
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.zero,
                      width: double.infinity,
                      height: double.infinity,
                      child: _AddServiceButton(
                        onPressed: () => widget.onAddSubRow!(item, index),
                        title: widget.subRowTitle?.call(item, index) ?? 'common.add'.tr(),
                        rowIndex: index,
                      ),
                    ),
                  ),
                ),
              ),
              // Add pre-generated empty cells
              ...addButtonEmptyCells,
            ],
          ));
        }
      }
    }


    return rows;
  }
}

// Add Service Button with loading state
class _AddServiceButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final int rowIndex;

  const _AddServiceButton({
    required this.onPressed,
    required this.title,
    required this.rowIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Try to get NewBookingCubit if available (for loading state)
    try {
      context.read<NewBookingCubit>();
      return BlocBuilder<NewBookingCubit, NewBookingState>(
        buildWhen: (previous, current) {
          // Rebuild when adding service state changes for this row
          if (previous is NewBookingAddingService && previous.rowIndex == rowIndex) {
            return true;
          }
          if (current is NewBookingAddingService && current.rowIndex == rowIndex) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          final isLoading = state is NewBookingAddingService && state.rowIndex == rowIndex;
          return ElevatedButton.icon(
            onPressed: isLoading ? null : onPressed,
            icon: isLoading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColor.YELLOW),
                    ),
                  )
                : Icon(Icons.add, size: 22, color: AppColor.YELLOW), // Orange icon
            label: Text(
              title,
              style: TextStyle(
                fontSize: 14, // Larger text
                fontWeight: FontWeight.w500,
                color: AppColor.YELLOW, // Orange text
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                isLoading 
                    ? AppColor.YELLOW.withOpacity(0.05)
                    : AppColor.YELLOW.withOpacity(0.1), // Lighter orange background
              ),
              foregroundColor: MaterialStateProperty.all(
                AppColor.YELLOW, // Orange foreground
              ),
              overlayColor: MaterialStateProperty.all(Colors.transparent), // No hover effect
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(
                  horizontal: 16, // More horizontal padding
                  vertical: 12, // More vertical padding
                ),
              ),
              minimumSize: MaterialStateProperty.all(
                const Size(120, 44), // Minimum size for touch target
              ),
              tapTargetSize: MaterialTapTargetSize.padded, // Larger tap target
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: AppColor.YELLOW, // Orange border
                    width: 1.5,
                  ),
                ),
              ),
              elevation: MaterialStateProperty.all(0), // Remove elevation for flat design
              splashFactory: NoSplash.splashFactory,
              enableFeedback: false,
            ),
          );
        },
      );
    } catch (e) {
      // If NewBookingCubit is not available, use simple button
    }
    
    // Fallback: Simple button without loading (for generic tables)
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(Icons.add, size: 22, color: AppColor.YELLOW),
      label: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColor.YELLOW,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          AppColor.YELLOW.withOpacity(0.1),
        ),
        foregroundColor: MaterialStateProperty.all(AppColor.YELLOW),
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        minimumSize: MaterialStateProperty.all(const Size(120, 44)),
        tapTargetSize: MaterialTapTargetSize.padded,
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: AppColor.YELLOW, width: 1.5),
          ),
        ),
        elevation: MaterialStateProperty.all(0),
        splashFactory: NoSplash.splashFactory,
        enableFeedback: false,
      ),
    );
  }
}
