import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/pickup_item_entity.dart';
import 'package:the_dunes/features/pickup_times/presentation/widgets/pickup_item_card.dart';

class PickupTimesAllItemsTab extends StatelessWidget {
  final List<PickupItemEntity> allItems;
  final Set<String> selectedItemIds;

  const PickupTimesAllItemsTab({
    super.key,
    required this.allItems,
    required this.selectedItemIds,
  });

  @override
  Widget build(BuildContext context) {
    if (allItems.isEmpty) {
      return Center(
        child: Text('pickup_times.no_items'.tr()),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: allItems.length,
      itemBuilder: (context, index) {
        final item = allItems[index];
        final itemId = item.type == 'booking'
            ? 'booking_${item.booking?.id}'
            : 'voucher_${item.voucher?.id}';
        return PickupItemCard(
          booking: item.booking,
          voucher: item.voucher,
          isSelected: selectedItemIds.contains(itemId),
        );
      },
    );
  }
}

