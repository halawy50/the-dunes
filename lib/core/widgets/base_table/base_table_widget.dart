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
    this.autoExpandAllOnInit = false,
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
  final bool autoExpandAllOnInit;

  @override
  State<BaseTableWidget<T>> createState() => _BaseTableWidgetState<T>();
}

class _BaseTableWidgetState<T> extends State<BaseTableWidget<T>> {
  final Map<int, bool> _expandedRows = {};
  // Cache for sub-columns to avoid rebuilding them
  final Map<int, List<BaseTableColumn<dynamic>>> _subColumnsCache = {};
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    _isInitialLoad = true;
    
    // Auto-expand all rows on initial load if requested
    if (widget.autoExpandAllOnInit && widget.getSubRows != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            for (int i = 0; i < widget.data.length; i++) {
              final subRows = widget.getSubRows!(widget.data[i]);
              if (subRows.isNotEmpty) {
                _expandedRows[i] = true;
              }
            }
          });
        }
      });
    }
  }

  @override
  void didUpdateWidget(BaseTableWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Mark that initial load is complete after first update
    if (_isInitialLoad) {
      _isInitialLoad = false;
    }
    
    // عند تغيير البيانات (مثل تغيير الصفحة)، لا نفتح الصفوف تلقائياً
    // نتحقق من تغيير البيانات بطريقة أفضل - مقارنة جميع العناصر
    final dataLengthChanged = widget.data.length != oldWidget.data.length;
    bool dataReplaced = false;
    
    if (widget.data.length == oldWidget.data.length && 
        widget.data.isNotEmpty && 
        oldWidget.data.isNotEmpty) {
      // مقارنة جميع العناصر للتحقق من استبدال البيانات
      // إذا كان أي عنصر مختلف، فهذا يعني أن البيانات تغيرت بالكامل
      try {
        for (int i = 0; i < widget.data.length; i++) {
          // محاولة استخدام id إذا كان موجوداً (مثل BookingModel)
          final currentItem = widget.data[i];
          final oldItem = oldWidget.data[i];
          
          // محاولة الوصول إلى خاصية id إذا كانت موجودة
          bool itemsDifferent = false;
          try {
            // استخدام dynamic للوصول إلى id
            final currentId = (currentItem as dynamic).id;
            final oldId = (oldItem as dynamic).id;
            itemsDifferent = currentId != oldId;
          } catch (e) {
            // إذا لم يكن هناك id، نستخدم toString
            itemsDifferent = currentItem.toString() != oldItem.toString();
          }
          
          if (itemsDifferent) {
            dataReplaced = true;
            break;
          }
        }
      } catch (e) {
        // إذا فشلت المقارنة، نفترض أن البيانات تغيرت
        dataReplaced = true;
      }
    }
    
    // إذا تغيرت البيانات (صفحة جديدة أو استبدال)، نمسح حالة الصفوف المفتوحة دائماً
    if (dataReplaced || dataLengthChanged) {
      // دائماً نمسح جميع الصفوف المفتوحة عند تغيير البيانات
      _expandedRows.clear();
      return; // لا نفتح أي صفوف عند تغيير الصفحة
    }
    
    // فقط عند إضافة صف جديد (وليس تغيير الصفحة)، نفتحه تلقائياً
    final rowsAdded = widget.data.length > oldWidget.data.length;
    if (widget.getSubRows != null && rowsAdded) {
      final newRowIndex = widget.data.length - 1;
      if (newRowIndex < widget.data.length) {
        final newRow = widget.data[newRowIndex];
        final subRows = widget.getSubRows!(newRow);
        if (subRows.isNotEmpty) {
          if (mounted) {
            setState(() {
              _expandedRows[newRowIndex] = true;
            });
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

  bool _areAllRowsExpanded() {
    if (widget.getSubRows == null || widget.data.isEmpty) return false;
    bool hasAnySubRows = false;
    for (int i = 0; i < widget.data.length; i++) {
      final subRows = widget.getSubRows!(widget.data[i]);
      if (subRows.isNotEmpty) {
        hasAnySubRows = true;
        if (!(_expandedRows[i] ?? false)) {
          return false;
        }
      }
    }
    return hasAnySubRows;
  }

  void _collapseAllRows() {
    if (mounted && widget.getSubRows != null) {
      setState(() {
        // Check if all rows with sub-rows are expanded
        bool allExpanded = _areAllRowsExpanded();
        
        // Toggle: if all expanded, collapse all; otherwise expand all
        if (allExpanded) {
          // Close all sub-rows
          _expandedRows.clear();
        } else {
          // Expand all rows that have sub-rows
          for (int i = 0; i < widget.data.length; i++) {
            final subRows = widget.getSubRows!(widget.data[i]);
            if (subRows.isNotEmpty) {
              _expandedRows[i] = true;
            }
          }
        }
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
      dataRowMaxHeight: double.infinity,
      horizontalMargin: 0,
      columnSpacing: 0,
      columns: [
        if (widget.getSubRows != null)
          DataColumn(
            label: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
              child: Tooltip(
                message: 'common.collapse_all'.tr(),
                child: SizedBox(
                  width: 40,
                  child: Center(
                    child: Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          _collapseAllRows();
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                          ),
                          child: Icon(
                            _areAllRowsExpanded() ? Icons.expand_less : Icons.expand_more,
                            size: 18,
                            color: AppColor.BLACK,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (widget.showCheckbox)
          DataColumn(
            label: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
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
          return DataColumn(
            label: Padding(
              padding: col.headerPadding ?? 
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
              child: SizedBox(
                width: col.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    col.headerKey.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
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
      child: Container(
        decoration: BoxDecoration(
          color: widget.config.backgroundColor ?? AppColor.BLACK,
          borderRadius: BorderRadius.circular(widget.config.borderRadius ?? 8),
          border: widget.config.showBorder
              ? Border.all(color: AppColor.GRAY_D8D8D8)
              : null,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
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
      
      // Don't auto-expand rows on initial load - they should start collapsed
      // Only auto-expand newly added rows (handled in didUpdateWidget)
      final isExpanded = _expandedRows[index] ?? false;

      final mainRowCells = [
        if (widget.getSubRows != null)
          DataCell(
            SizedBox(
              width: 40,
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: hasSubRows ? () => _toggleRow(index) : null,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hasSubRows ? Colors.transparent : Colors.transparent,
                      ),
                      child: Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        size: 18,
                        color: hasSubRows ? AppColor.BLACK : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
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
                height: 56,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 5,
                    right: 5,
                    top: 12,
                    bottom: 8,
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
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
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
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
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
