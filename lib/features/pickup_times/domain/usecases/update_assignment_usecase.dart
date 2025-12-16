import 'package:the_dunes/features/pickup_times/domain/repositories/pickup_times_repository.dart';

class UpdateAssignmentUseCase {
  final PickupTimesRepository repository;

  UpdateAssignmentUseCase(this.repository);

  Future<Map<String, dynamic>> call({
    required String pickupGroupId,
    int? carNumber,
    String? driver,
    List<int>? addBookingIds,
    List<int>? addVoucherIds,
    List<int>? removeBookingIds,
    List<int>? removeVoucherIds,
  }) async {
    return await repository.updateAssignment(
      pickupGroupId: pickupGroupId,
      carNumber: carNumber,
      driver: driver,
      addBookingIds: addBookingIds,
      addVoucherIds: addVoucherIds,
      removeBookingIds: removeBookingIds,
      removeVoucherIds: removeVoucherIds,
    );
  }
}

