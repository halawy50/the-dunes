import 'package:the_dunes/features/pickup_times/domain/repositories/pickup_times_repository.dart';

class AssignVehicleUseCase {
  final PickupTimesRepository repository;

  AssignVehicleUseCase(this.repository);

  Future<Map<String, dynamic>> call({
    required int carNumber,
    String? driver,
    List<int>? bookingIds,
    List<int>? voucherIds,
  }) async {
    return await repository.assignVehicle(
      carNumber: carNumber,
      driver: driver,
      bookingIds: bookingIds,
      voucherIds: voucherIds,
    );
  }
}

