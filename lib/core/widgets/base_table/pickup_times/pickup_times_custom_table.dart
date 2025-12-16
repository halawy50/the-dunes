import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/features/pickup_times/presentation/models/pickup_table_item.dart';
import 'package:the_dunes/core/widgets/base_table/pickup_times/pickup_times_table_columns.dart';
import 'package:the_dunes/features/pickup_times/presentation/widgets/pickup_services_dialog.dart';

class PickupTimesCustomTable extends StatefulWidget {
  const PickupTimesCustomTable({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onItemSelect,
    required this.onItemStatusUpdate,
    required this.allItems,
    required this.startNumber,
  });

  final List<PickupTableItem> items;
  final List<PickupTableItem> selectedItems;
  final void Function(PickupTableItem, bool) onItemSelect;
  final void Function(PickupTableItem, String newStatus, String statusType) onItemStatusUpdate;
  final List<PickupTableItem> allItems;
  final int startNumber;

  @override
  State<PickupTimesCustomTable> createState() => _PickupTimesCustomTableState();
}

class _PickupTimesCustomTableState extends State<PickupTimesCustomTable> {
  void _showServicesDialog(PickupTableItem item) {
    PickupServicesDialog.show(context, item);
  }

  Map<String, int>? _groupColorIndexMap;

  @override
  void didUpdateWidget(PickupTimesCustomTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.allItems != widget.allItems) {
      _groupColorIndexMap = null;
    }
  }

  List<Color> _getGroupColors() {
    return [
      Colors.blue.shade300,
      Colors.green.shade300,
      Colors.orange.shade300,
      Colors.purple.shade300,
      Colors.teal.shade300,
      Colors.pink.shade300,
      Colors.amber.shade300,
      Colors.cyan.shade300,
      Colors.indigo.shade300,
      Colors.lime.shade300,
      Colors.red.shade300,
      Colors.brown.shade300,
      Colors.deepOrange.shade300,
      Colors.deepPurple.shade300,
      Colors.lightBlue.shade300,
      Colors.lightGreen.shade300,
    ];
  }

  Map<String, int> _buildGroupColorMap() {
    final groupColorMap = <String, int>{};
    final uniqueGroups = <String>{};
    
    for (final item in widget.allItems) {
      final groupId = item.pickupGroupId;
      if (groupId != null && groupId.isNotEmpty) {
        uniqueGroups.add(groupId);
      }
    }
    
    final sortedGroups = uniqueGroups.toList()..sort();
    for (int i = 0; i < sortedGroups.length; i++) {
      groupColorMap[sortedGroups[i]] = i;
    }
    
    return groupColorMap;
  }

  Color _getGroupBorderColor(String? groupId) {
    if (groupId == null || groupId.isEmpty) {
      return Colors.transparent;
    }
    
    _groupColorIndexMap ??= _buildGroupColorMap();
    final colors = _getGroupColors();
    final colorIndex = _groupColorIndexMap![groupId] ?? 0;
    
    return colors[colorIndex % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final columns = PickupTimesTableColumns.buildColumns(
      onItemStatusUpdate: widget.onItemStatusUpdate,
      startNumber: widget.startNumber,
      allItems: widget.allItems,
      startIndex: widget.startNumber - 1,
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColor.WHITE,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Table(
            border: TableBorder.all(color: AppColor.GRAY_D8D8D8),
            columnWidths: _buildColumnWidths(columns),
            children: _buildTableRows(columns),
          ),
        ),
      ),
    );
  }


  Map<int, TableColumnWidth> _buildColumnWidths(List<BaseTableColumn<PickupTableItem>> columns) {
    final widths = <int, TableColumnWidth>{};
    int colIndex = 0;
    
    widths[colIndex++] = const FixedColumnWidth(6); // Group indicator column
    widths[colIndex++] = const FixedColumnWidth(40);
    widths[colIndex++] = const FixedColumnWidth(48);
    
    for (final col in columns) {
      widths[colIndex++] = FixedColumnWidth(col.width ?? 100.0);
    }
    
    return widths;
  }

  List<TableRow> _buildTableRows(List<BaseTableColumn<PickupTableItem>> columns) {
    final rows = <TableRow>[];
    
    rows.add(_buildHeaderRow(columns));
    
    // Build rows for each item in the current page
    // Group items that are in the same group and appear together
    final processedIndices = <int>{};
    
    for (int i = 0; i < widget.items.length; i++) {
      if (processedIndices.contains(i)) continue;
      
      final item = widget.items[i];
      final groupId = item.pickupGroupId;
      
      if (groupId != null && groupId.isNotEmpty) {
        // Find all items in the same group that are in the current page
        final groupItems = <PickupTableItem>[];
        for (int j = i; j < widget.items.length; j++) {
          if (widget.items[j].pickupGroupId == groupId) {
            groupItems.add(widget.items[j]);
            processedIndices.add(j);
          } else {
            break; // Items are sorted, so if we find a different group, stop
          }
        }
        
        if (groupItems.length > 1) {
          rows.addAll(_buildGroupedRows(groupItems, columns, groupId, i));
        } else {
          rows.addAll(_buildSingleRowWithServices(item, columns, i));
        }
      } else {
        rows.addAll(_buildSingleRowWithServices(item, columns, i));
        processedIndices.add(i);
      }
    }
    
    return rows;
  }

  TableRow _buildHeaderRow(List<BaseTableColumn<PickupTableItem>> columns) {
    return TableRow(
      decoration: BoxDecoration(color: AppColor.GRAY_F6F6F6),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: const SizedBox(height: 40), // Group indicator column
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: const SizedBox(height: 40), // Info icon column
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: Checkbox(
              value: widget.selectedItems.length == widget.items.length && widget.items.isNotEmpty,
              onChanged: (value) {
                for (var item in widget.items) {
                  widget.onItemSelect(item, value ?? false);
                }
              },
            ),
          ),
        ),
        ...columns.map((col) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          child: Container(
            constraints: const BoxConstraints(minHeight: 40),
            alignment: Alignment.centerLeft,
            child: Text(
              col.headerKey.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            ),
          ),
        )),
      ],
    );
  }

  List<TableRow> _buildGroupedRows(
    List<PickupTableItem> groupItems,
    List<BaseTableColumn<PickupTableItem>> columns,
    String groupId,
    int startIndex,
  ) {
    final rows = <TableRow>[];
    final rowHeight = 40.0;
    
    for (int i = 0; i < groupItems.length; i++) {
      final item = groupItems[i];
      final isSelected = widget.selectedItems.contains(item);
      final itemIndex = widget.items.indexOf(item);
      final hasServices = item.services.isNotEmpty;
      
      final groupBorderColor = _getGroupBorderColor(groupId);
      
      final cells = <Widget>[
        // Group indicator column
        TableCell(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              height: rowHeight,
              decoration: BoxDecoration(
                color: groupBorderColor,
                border: Border(
                  left: BorderSide(
                    color: groupBorderColor,
                    width: 4,
                  ),
                ),
              ),
            ),
          ),
        ),
        // Info icon column
        TableCell(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              height: rowHeight,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (hasServices)
                    InkWell(
                      onTap: () => _showServicesDialog(item),
                      child: Icon(
                        Icons.info_outline,
                        size: 18,
                        color: AppColor.BLACK,
                      ),
                    ),
                  if (hasServices) const SizedBox(width: 4),
                  Text('${widget.startNumber + itemIndex}'),
                ],
              ),
            ),
          ),
        ),
        // Checkbox column
        TableCell(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              height: rowHeight,
              alignment: Alignment.center,
              child: Checkbox(
                value: isSelected,
                onChanged: (value) => widget.onItemSelect(item, value ?? false),
              ),
            ),
          ),
        ),
      ];
      
      // Get the first item in the group to use its car number and driver for all rows
      final firstItemInGroup = groupItems[0];
      
      for (int colIndex = 0; colIndex < columns.length; colIndex++) {
        final col = columns[colIndex];
        final isCarNumber = col.headerKey == 'booking.car_number';
        final isDriver = col.headerKey == 'booking.driver';
        final isCarNumberOrDriver = isCarNumber || isDriver;
        
        if (isCarNumberOrDriver) {
          // Use the first item's car number and driver for all rows in the group
          cells.add(TableCell(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                height: rowHeight,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: col.cellBuilder(firstItemInGroup, widget.items.indexOf(firstItemInGroup)),
                  ),
                ),
              ),
            ),
          ));
        } else {
          cells.add(TableCell(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                height: rowHeight,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: col.cellBuilder(item, itemIndex),
                  ),
                ),
              ),
            ),
          ));
        }
      }
      
      rows.add(TableRow(children: cells));
    }
    
    return rows;
  }

  List<TableRow> _buildSingleRowWithServices(PickupTableItem item, List<BaseTableColumn<PickupTableItem>> columns, int index) {
    final rows = <TableRow>[];
    final isSelected = widget.selectedItems.contains(item);
    final hasServices = item.services.isNotEmpty;
    
    final isUnassigned = item.pickupGroupId == null || (item.pickupGroupId?.isEmpty ?? true);
    
    rows.add(TableRow(
      children: [
        // Group indicator column (empty for unassigned)
        TableCell(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              height: 40,
              decoration: isUnassigned
                  ? BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: Colors.grey.shade400,
                          width: 4,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
        ),
        // Info icon column
        TableCell(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              height: 40,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (hasServices)
                    InkWell(
                      onTap: () => _showServicesDialog(item),
                      child: Icon(
                        Icons.info_outline,
                        size: 18,
                        color: AppColor.BLACK,
                      ),
                    ),
                  if (hasServices) const SizedBox(width: 4),
                  Text('${widget.startNumber + index}'),
                ],
              ),
            ),
          ),
        ),
        // Checkbox column
        TableCell(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              height: 40,
              alignment: Alignment.center,
              child: Checkbox(
                value: isSelected,
                onChanged: (value) => widget.onItemSelect(item, value ?? false),
              ),
            ),
          ),
        ),
        ...columns.map((col) => TableCell(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              height: 40,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: col.cellBuilder(item, index),
                ),
              ),
            ),
          ),
        )),
      ],
    ));
    
    return rows;
  }
}

