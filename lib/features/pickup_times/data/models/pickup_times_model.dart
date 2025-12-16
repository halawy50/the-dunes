import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:the_dunes/features/pickup_times/domain/entities/pickup_times_entity.dart';
import 'package:the_dunes/features/pickup_times/data/models/vehicle_group_model.dart';
import 'package:the_dunes/features/pickup_times/data/models/pickup_item_model.dart';
import 'package:the_dunes/features/pickup_times/data/models/pickup_booking_model.dart';
import 'package:the_dunes/features/pickup_times/data/models/pickup_voucher_model.dart';

class PickupTimesModel extends PickupTimesEntity {
  PickupTimesModel({
    required super.vehicleGroups,
    required super.unassigned,
    required super.allItems,
  });

  factory PickupTimesModel.fromJson(Map<String, dynamic> json) {
    // Handle response structure: {success, message, data} or direct {data}
    final data = json['data'] as Map<String, dynamic>? ?? json;
    
    if (kDebugMode) {
      print('[PickupTimesModel] Parsing response...');
      print('[PickupTimesModel] Has vehicleGroups: ${data.containsKey('vehicleGroups')}');
      print('[PickupTimesModel] Has unassigned: ${data.containsKey('unassigned')}');
      print('[PickupTimesModel] Has allItems: ${data.containsKey('allItems')}');
    }
    
    return PickupTimesModel(
      vehicleGroups: (data['vehicleGroups'] as List<dynamic>?)
              ?.map((e) => VehicleGroupModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      unassigned: UnassignedItemsModel.fromJson(
        data['unassigned'] as Map<String, dynamic>? ?? {},
      ),
      allItems: (data['allItems'] as List<dynamic>?)
              ?.map((e) => PickupItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class UnassignedItemsModel extends UnassignedItemsEntity {
  UnassignedItemsModel({
    required super.bookings,
    required super.vouchers,
  });

  factory UnassignedItemsModel.fromJson(Map<String, dynamic> json) {
    return UnassignedItemsModel(
      bookings: (json['bookings'] as List<dynamic>?)
              ?.map((e) => PickupBookingModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      vouchers: (json['vouchers'] as List<dynamic>?)
              ?.map((e) => PickupVoucherModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

