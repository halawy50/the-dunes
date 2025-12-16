import 'package:the_dunes/features/pickup_times/domain/entities/pickup_times_entity.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/vehicle_group_simple_entity.dart';

abstract class PickupTimesRepository {
  Future<PickupTimesEntity> getPickupTimes();
  Future<List<VehicleGroupSimpleEntity>> getVehicleGroups();
  Future<Map<String, dynamic>> assignVehicle({
    required int carNumber,
    String? driver,
    List<int>? bookingIds,
    List<int>? voucherIds,
  });
  Future<Map<String, dynamic>> updateAssignment({
    required String pickupGroupId,
    int? carNumber,
    String? driver,
    List<int>? addBookingIds,
    List<int>? addVoucherIds,
    List<int>? removeBookingIds,
    List<int>? removeVoucherIds,
  });
  Future<Map<String, dynamic>> removeAssignment({
    List<int>? bookingIds,
    List<int>? voucherIds,
  });
  Future<Map<String, dynamic>> updateVoucherStatus({
    required int voucherId,
    String? status,
    String? pickupStatus,
  });
  Future<Map<String, dynamic>> updateBookingStatus({
    required int bookingId,
    String? status,
    String? pickupStatus,
  });
  Future<Map<String, dynamic>> updatePickupTimeStatus({
    required int id,
    required String type,
    required String status,
    required String statusType,
  });
}

