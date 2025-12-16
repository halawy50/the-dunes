import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/vehicle_group_entity.dart';
import 'package:the_dunes/features/pickup_times/presentation/cubit/pickup_times_cubit.dart';
import 'package:the_dunes/features/pickup_times/presentation/widgets/pickup_item_card.dart';
import 'package:the_dunes/features/pickup_times/presentation/widgets/vehicle_group_card.dart';

class PickupTimesGroupsTab extends StatelessWidget {
  final List<VehicleGroupEntity> vehicleGroups;
  final Set<String> selectedItemIds;

  const PickupTimesGroupsTab({
    super.key,
    required this.vehicleGroups,
    required this.selectedItemIds,
  });

  @override
  Widget build(BuildContext context) {
    if (vehicleGroups.isEmpty) {
      return Center(
        child: Text('pickup_times.no_items'.tr()),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: vehicleGroups.length,
      itemBuilder: (context, index) {
        final group = vehicleGroups[index];
        return VehicleGroupCard(
          group: group,
          selectedItemIds: selectedItemIds,
        );
      },
    );
  }
}

