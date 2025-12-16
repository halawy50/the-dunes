import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/pickup_times_entity.dart';
import 'package:the_dunes/features/pickup_times/presentation/widgets/pickup_times_all_items_tab.dart';
import 'package:the_dunes/features/pickup_times/presentation/widgets/pickup_times_groups_tab.dart';
import 'package:the_dunes/features/pickup_times/presentation/widgets/pickup_times_unassigned_tab.dart';

class PickupTimesTabs extends StatefulWidget {
  final PickupTimesEntity pickupTimes;
  final Set<String> selectedItemIds;

  const PickupTimesTabs({
    super.key,
    required this.pickupTimes,
    required this.selectedItemIds,
  });

  @override
  State<PickupTimesTabs> createState() => _PickupTimesTabsState();
}

class _PickupTimesTabsState extends State<PickupTimesTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'pickup_times.assigned_groups'.tr()),
            Tab(text: 'pickup_times.unassigned'.tr()),
            Tab(text: 'pickup_times.all_items'.tr()),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              PickupTimesGroupsTab(
                vehicleGroups: widget.pickupTimes.vehicleGroups,
                selectedItemIds: widget.selectedItemIds,
              ),
              PickupTimesUnassignedTab(
                unassigned: widget.pickupTimes.unassigned,
                selectedItemIds: widget.selectedItemIds,
              ),
              PickupTimesAllItemsTab(
                allItems: widget.pickupTimes.allItems,
                selectedItemIds: widget.selectedItemIds,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

