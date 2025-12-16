import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/widgets/base_table/pickup_times/pickup_times_custom_table.dart';
import 'package:the_dunes/features/pickup_times/presentation/models/pickup_table_item.dart';
import 'package:the_dunes/features/pickup_times/presentation/cubit/pickup_times_cubit.dart';
import 'package:the_dunes/features/pickup_times/presentation/cubit/pickup_times_state.dart';

class PickupTimesTableWidget extends StatelessWidget {
  const PickupTimesTableWidget({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onItemSelect,
    required this.onItemStatusUpdate,
    this.allItems,
  });

  final List<PickupTableItem> items;
  final List<PickupTableItem> selectedItems;
  final void Function(PickupTableItem, bool) onItemSelect;
  final void Function(PickupTableItem, String newStatus, String statusType) onItemStatusUpdate;
  final List<PickupTableItem>? allItems;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PickupTimesCubit>();
    final state = cubit.state;
    final currentPage = state is PickupTimesLoaded ? state.currentPage : 1;
    final pageSize = state is PickupTimesLoaded ? state.pageSize : 20;
    final startNumber = (currentPage - 1) * pageSize + 1;

    return PickupTimesCustomTable(
      items: items,
      selectedItems: selectedItems,
      onItemSelect: onItemSelect,
      onItemStatusUpdate: onItemStatusUpdate,
      allItems: allItems ?? items,
      startNumber: startNumber,
    );
  }
}

