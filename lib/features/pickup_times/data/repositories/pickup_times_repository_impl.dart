import 'package:the_dunes/features/pickup_times/data/datasources/pickup_times_remote_data_source.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/pickup_times_entity.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/vehicle_group_simple_entity.dart';
import 'package:the_dunes/features/pickup_times/domain/repositories/pickup_times_repository.dart';

class PickupTimesRepositoryImpl implements PickupTimesRepository {
  final PickupTimesRemoteDataSource remoteDataSource;

  PickupTimesRepositoryImpl(this.remoteDataSource);

  @override
  Future<PickupTimesEntity> getPickupTimes() async {
    final model = await remoteDataSource.getPickupTimes();
    return model;
  }

  @override
  Future<List<VehicleGroupSimpleEntity>> getVehicleGroups() async {
    final models = await remoteDataSource.getVehicleGroups();
    return models;
  }

  @override
  Future<Map<String, dynamic>> assignVehicle({
    required int carNumber,
    String? driver,
    List<int>? bookingIds,
    List<int>? voucherIds,
  }) async {
    return await remoteDataSource.assignVehicle(
      carNumber: carNumber,
      driver: driver,
      bookingIds: bookingIds,
      voucherIds: voucherIds,
    );
  }

  @override
  Future<Map<String, dynamic>> updateAssignment({
    required String pickupGroupId,
    int? carNumber,
    String? driver,
    List<int>? addBookingIds,
    List<int>? addVoucherIds,
    List<int>? removeBookingIds,
    List<int>? removeVoucherIds,
  }) async {
    return await remoteDataSource.updateAssignment(
      pickupGroupId: pickupGroupId,
      carNumber: carNumber,
      driver: driver,
      addBookingIds: addBookingIds,
      addVoucherIds: addVoucherIds,
      removeBookingIds: removeBookingIds,
      removeVoucherIds: removeVoucherIds,
    );
  }

  @override
  Future<Map<String, dynamic>> removeAssignment({
    List<int>? bookingIds,
    List<int>? voucherIds,
  }) async {
    return await remoteDataSource.removeAssignment(
      bookingIds: bookingIds,
      voucherIds: voucherIds,
    );
  }

  @override
  Future<Map<String, dynamic>> updateVoucherStatus({
    required int voucherId,
    String? status,
    String? pickupStatus,
  }) async {
    return await remoteDataSource.updateVoucherStatus(
      voucherId: voucherId,
      status: status,
      pickupStatus: pickupStatus,
    );
  }

  @override
  Future<Map<String, dynamic>> updateBookingStatus({
    required int bookingId,
    String? status,
    String? pickupStatus,
  }) async {
    return await remoteDataSource.updateBookingStatus(
      bookingId: bookingId,
      status: status,
      pickupStatus: pickupStatus,
    );
  }

  @override
  Future<Map<String, dynamic>> updatePickupTimeStatus({
    required int id,
    required String type,
    required String status,
    required String statusType,
  }) async {
    return await remoteDataSource.updatePickupTimeStatus(
      id: id,
      type: type,
      status: status,
      statusType: statusType,
    );
  }
}

