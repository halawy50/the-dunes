import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/vehicle_group_entity.dart';
import 'package:the_dunes/features/pickup_times/presentation/cubit/pickup_times_cubit.dart';
import 'package:the_dunes/features/pickup_times/presentation/widgets/pickup_item_card.dart';
import 'package:the_dunes/features/pickup_times/presentation/widgets/assign_vehicle_dialog.dart';

class VehicleGroupCard extends StatelessWidget {
  final VehicleGroupEntity group;
  final Set<String> selectedItemIds;

  const VehicleGroupCard({
    super.key,
    required this.group,
    required this.selectedItemIds,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ExpansionTile(
        leading: const Icon(Icons.directions_car),
        title: Text('${'pickup_times.car_number'.tr()}: ${group.carNumber}'),
        subtitle: Text('${'pickup_times.driver'.tr()}: ${group.driver}'),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AssignVehicleDialog(
                existingGroup: group,
              ),
            );
          },
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${'pickup_times.total_items'.tr()}: ${group.totalItems}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (group.bookings.isNotEmpty) ...[
                  Text(
                    'pickup_times.bookings'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...group.bookings.map((booking) => PickupItemCard(
                        booking: booking,
                        voucher: null,
                        isSelected: selectedItemIds.contains('booking_${booking.id}'),
                      )),
                ],
                if (group.vouchers.isNotEmpty) ...[
                  Text(
                    'pickup_times.vouchers'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...group.vouchers.map((voucher) => PickupItemCard(
                        booking: null,
                        voucher: voucher,
                        isSelected: selectedItemIds.contains('voucher_${voucher.id}'),
                      )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

