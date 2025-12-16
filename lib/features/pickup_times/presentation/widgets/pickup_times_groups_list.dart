import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/vehicle_group_simple_entity.dart';
import 'package:the_dunes/features/pickup_times/presentation/cubit/pickup_times_cubit.dart';
import 'package:the_dunes/features/pickup_times/presentation/cubit/pickup_times_state.dart';
import 'package:the_dunes/features/pickup_times/presentation/models/pickup_table_item.dart';

class PickupTimesGroupsList extends StatefulWidget {
  const PickupTimesGroupsList({super.key});

  @override
  State<PickupTimesGroupsList> createState() => _PickupTimesGroupsListState();
}

class _PickupTimesGroupsListState extends State<PickupTimesGroupsList> {
  List<VehicleGroupSimpleEntity> _groups = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    setState(() => _isLoading = true);
    try {
      final cubit = context.read<PickupTimesCubit>();
      final groups = await cubit.getVehicleGroups();
      if (mounted) {
        setState(() {
          _groups = groups;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleAddToGroup(VehicleGroupSimpleEntity group) async {
    final cubit = context.read<PickupTimesCubit>();
    final state = cubit.state;
    
    if (state is! PickupTimesLoaded) return;
    
    final selectedIds = state.selectedItemIds;
    if (selectedIds.isEmpty) return;

    final bookingIds = selectedIds
        .where((id) => id.startsWith('booking_'))
        .map((id) => int.parse(id.replaceFirst('booking_', '')))
        .toList();
    final voucherIds = selectedIds
        .where((id) => id.startsWith('voucher_'))
        .map((id) => int.parse(id.replaceFirst('voucher_', '')))
        .toList();

    final allItems = _getAllItemsFromState(state);
    final itemsInGroup = allItems
        .where((item) => item.pickupGroupId == group.pickupGroupId)
        .map((item) => item.type == 'booking'
            ? 'booking_${item.booking!.id}'
            : 'voucher_${item.voucher!.id}')
        .toSet();

    final duplicateIds = selectedIds.intersection(itemsInGroup);
    if (duplicateIds.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('pickup_times.items_already_in_group'.tr()),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    await cubit.updateAssignment(
      pickupGroupId: group.pickupGroupId,
      addBookingIds: bookingIds.isNotEmpty ? bookingIds : null,
      addVoucherIds: voucherIds.isNotEmpty ? voucherIds : null,
    );
  }

  List<PickupTableItem> _getAllItemsFromState(PickupTimesLoaded state) {
    final items = <PickupTableItem>[];
    for (final group in state.pickupTimes.vehicleGroups) {
      for (final booking in group.bookings) {
        items.add(PickupTableItem(
          type: 'booking',
          booking: booking,
          pickupGroupId: group.pickupGroupId,
          carNumber: group.carNumber,
          driver: group.driver,
        ));
      }
      for (final voucher in group.vouchers) {
        items.add(PickupTableItem(
          type: 'voucher',
          voucher: voucher,
          pickupGroupId: group.pickupGroupId,
          carNumber: group.carNumber,
          driver: group.driver,
        ));
      }
    }
    for (final booking in state.pickupTimes.unassigned.bookings) {
      items.add(PickupTableItem(type: 'booking', booking: booking));
    }
    for (final voucher in state.pickupTimes.unassigned.vouchers) {
      items.add(PickupTableItem(type: 'voucher', voucher: voucher));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PickupTimesCubit, PickupTimesState>(
      builder: (context, state) {
        final selectedCount = state is PickupTimesLoaded
            ? state.selectedItemIds.length
            : 0;

        if (selectedCount == 0) {
          return const SizedBox.shrink();
        }

        if (_isLoading) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (_groups.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          color: AppColor.WHITE,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'pickup_times.add_to_existing_group'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _groups.map((group) {
                  final displayText = group.carNumber != null
                      ? '${'pickup_times.car_number'.tr()}: ${group.carNumber}'
                      : '';
                  final driverText = group.driver != null &&
                          group.driver!.isNotEmpty
                      ? '${'pickup_times.driver'.tr()}: ${group.driver}'
                      : '';
                  final itemsText =
                      '${'pickup_times.total_items'.tr()}: ${group.totalItems}';
                  final fullText = [displayText, driverText, itemsText]
                      .where((t) => t.isNotEmpty)
                      .join(' - ');

                  return OutlinedButton(
                    onPressed: () => _handleAddToGroup(group),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColor.YELLOW),
                    ),
                    child: Text(fullText),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

