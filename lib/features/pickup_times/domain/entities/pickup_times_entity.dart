import 'package:the_dunes/features/pickup_times/domain/entities/pickup_booking_entity.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/pickup_item_entity.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/pickup_voucher_entity.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/vehicle_group_entity.dart';

class PickupTimesEntity {
  final List<VehicleGroupEntity> vehicleGroups;
  final UnassignedItemsEntity unassigned;
  final List<PickupItemEntity> allItems;

  PickupTimesEntity({
    required this.vehicleGroups,
    required this.unassigned,
    required this.allItems,
  });
}

class UnassignedItemsEntity {
  final List<PickupBookingEntity> bookings;
  final List<PickupVoucherEntity> vouchers;

  UnassignedItemsEntity({
    required this.bookings,
    required this.vouchers,
  });
}

