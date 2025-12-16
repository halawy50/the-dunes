import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/pickup_times/presentation/cubit/pickup_times_cubit.dart';
import 'package:the_dunes/features/pickup_times/presentation/widgets/assign_vehicle_dialog.dart';

class PickupTimesHeader extends StatelessWidget {
  final int selectedCount;

  const PickupTimesHeader({
    super.key,
    required this.selectedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      color: AppColor.WHITE,
      child: Row(
        children: [
          Text(
            'pickup_times.title'.tr(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (selectedCount > 0)
            Text(
              '$selectedCount ${'pickup_times.items_selected'.tr()}',
              style: const TextStyle(fontSize: 16),
            ),
          if (selectedCount > 0) const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {
              _showAssignDialog(context);
            },
            icon: const Icon(Icons.add),
            label: Text('pickup_times.create_group'.tr()),
          ),
          if (selectedCount > 0) ...[
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: () {
                context.read<PickupTimesCubit>().clearSelection();
              },
              icon: const Icon(Icons.clear),
              label: Text('common.clear'.tr()),
            ),
          ],
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<PickupTimesCubit>().loadPickupTimes();
            },
            tooltip: 'pickup_times.refresh'.tr(),
          ),
        ],
      ),
    );
  }

  void _showAssignDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AssignVehicleDialog(),
    );
  }
}

