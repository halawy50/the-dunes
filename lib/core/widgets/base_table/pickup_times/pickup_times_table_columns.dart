import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_cell_factory.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/features/pickup_times/presentation/models/pickup_table_item.dart';
import 'package:the_dunes/core/widgets/base_table/pickup_times/pickup_times_table_helpers.dart';

class PickupTimesTableColumns {
  static List<BaseTableColumn<PickupTableItem>> buildColumns({
    required void Function(PickupTableItem, String newStatus, String statusType) onItemStatusUpdate,
    required int startNumber,
    List<PickupTableItem>? allItems,
    int startIndex = 0,
  }) {
    return [
      BaseTableColumn<PickupTableItem>(
        headerKey: 'booking.num',
        width: 60,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: '${startNumber + index}',
        ),
      ),
      BaseTableColumn<PickupTableItem>(
        headerKey: 'pickup_times.type',
        width: 100,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.type == 'booking' 
              ? 'pickup_times.booking'.tr() 
              : 'pickup_times.voucher'.tr(),
        ),
      ),
      BaseTableColumn<PickupTableItem>(
        headerKey: 'booking.car_number',
        width: 100,
        cellBuilder: (item, index) {
          // Calculate global index: local index + start index from pagination
          final globalIndex = startIndex + index;
          final shouldShow = _shouldShowGroupInfo(item, globalIndex, allItems);
          if (!shouldShow) {
            return const SizedBox.shrink();
          }
          // Use carNumber from PickupTableItem (from group), not from booking/voucher
          final carNumber = item.carNumber;
          return BaseTableCellFactory.text(
            text: carNumber != null ? carNumber.toString() : '-',
          );
        },
      ),
      BaseTableColumn<PickupTableItem>(
        headerKey: 'booking.driver',
        width: 100,
        cellBuilder: (item, index) {
          // Calculate global index: local index + start index from pagination
          final globalIndex = startIndex + index;
          final shouldShow = _shouldShowGroupInfo(item, globalIndex, allItems);
          if (!shouldShow) {
            return const SizedBox.shrink();
          }
          // Use driver from PickupTableItem (from group), not from booking/voucher
          final driver = item.driver;
          return BaseTableCellFactory.text(
            text: driver != null && driver.isNotEmpty ? driver : '-',
          );
        },
      ),
      BaseTableColumn<PickupTableItem>(
        headerKey: 'booking.guest_name',
        width: 180,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.guestName,
        ),
      ),
      BaseTableColumn<PickupTableItem>(
        headerKey: 'booking.phone_number',
        width: 150,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.phoneNumber,
        ),
      ),
      BaseTableColumn<PickupTableItem>(
        headerKey: 'booking.status',
        width: 160,
        cellBuilder: (item, index) => PickupTimesTableHelpers.buildStatusDropdown(
          item,
          onItemStatusUpdate,
          false, // isLoading - can be passed from parent if needed
        ),
      ),
      BaseTableColumn<PickupTableItem>(
        headerKey: 'booking.pickup_time_col',
        width: 150,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.pickupTime ?? '-',
        ),
      ),
      BaseTableColumn<PickupTableItem>(
        headerKey: 'booking.pickup_status',
        width: 140,
        cellBuilder: (item, index) => PickupTimesTableHelpers.buildPickupStatusDropdown(
          item,
          onItemStatusUpdate,
          false, // isLoading - can be passed from parent if needed
        ),
      ),
      BaseTableColumn<PickupTableItem>(
        headerKey: 'booking.location',
        width: 120,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.location ?? '-',
        ),
      ),
      BaseTableColumn<PickupTableItem>(
        headerKey: 'booking.agent_name',
        width: 120,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.agentName ?? '-',
        ),
      ),
      BaseTableColumn<PickupTableItem>(
        headerKey: 'booking.hotel_name',
        width: 200,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.hotel ?? '-',
        ),
      ),
      BaseTableColumn<PickupTableItem>(
        headerKey: 'booking.room',
        width: 80,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.room?.toString() ?? '-',
        ),
      ),
      BaseTableColumn<PickupTableItem>(
        headerKey: 'booking.payment',
        width: 100,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.payment,
        ),
      ),
      BaseTableColumn<PickupTableItem>(
        headerKey: 'booking.t_revenue',
        width: 130,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: '${item.finalPrice.toStringAsFixed(2)} AED',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ),
    ];
  }

  static bool _shouldShowGroupInfo(PickupTableItem item, int globalIndex, List<PickupTableItem>? allItems) {
    // If no allItems or invalid index, show the info
    if (allItems == null || allItems.isEmpty) return true;
    if (globalIndex < 0 || globalIndex >= allItems.length) {
      // If index not found, show info as fallback
      return true;
    }
    
    // If item is not in a group, show the info
    final itemGroupId = item.pickupGroupId;
    if (itemGroupId == null || itemGroupId.isEmpty) return true;
    
    // If this is the first item in the list, show the info
    if (globalIndex == 0) return true;
    
    // Get the previous item
    final previousItem = allItems[globalIndex - 1];
    final previousGroupId = previousItem.pickupGroupId;
    
    // If previous item is not in a group, show the info
    if (previousGroupId == null || previousGroupId.isEmpty) return true;
    
    // If previous item is in a different group, show the info (this is the first item in this group)
    if (previousGroupId != itemGroupId) return true;
    
    // If previous item is in the same group, don't show (merge with previous)
    return false;
  }
}

