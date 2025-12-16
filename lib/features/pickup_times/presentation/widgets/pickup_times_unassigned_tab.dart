import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/pickup_times_entity.dart';
import 'package:the_dunes/features/pickup_times/presentation/widgets/pickup_item_card.dart';

class PickupTimesUnassignedTab extends StatelessWidget {
  final UnassignedItemsEntity unassigned;
  final Set<String> selectedItemIds;

  const PickupTimesUnassignedTab({
    super.key,
    required this.unassigned,
    required this.selectedItemIds,
  });

  @override
  Widget build(BuildContext context) {
    final allUnassigned = [
      ...unassigned.bookings.map((b) => 'booking_${b.id}'),
      ...unassigned.vouchers.map((v) => 'voucher_${v.id}'),
    ];

    if (allUnassigned.isEmpty) {
      return Center(
        child: Text('pickup_times.no_items'.tr()),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        if (unassigned.bookings.isNotEmpty) ...[
          Text(
            'pickup_times.bookings'.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...unassigned.bookings.map((booking) => PickupItemCard(
                booking: booking,
                voucher: null,
                isSelected: selectedItemIds.contains('booking_${booking.id}'),
              )),
          const SizedBox(height: 16),
        ],
        if (unassigned.vouchers.isNotEmpty) ...[
          Text(
            'pickup_times.vouchers'.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...unassigned.vouchers.map((voucher) => PickupItemCard(
                booking: null,
                voucher: voucher,
                isSelected: selectedItemIds.contains('voucher_${voucher.id}'),
              )),
        ],
      ],
    );
  }
}

