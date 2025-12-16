import 'package:the_dunes/features/pickup_times/domain/repositories/pickup_times_repository.dart';

class RemoveAssignmentUseCase {
  final PickupTimesRepository repository;

  RemoveAssignmentUseCase(this.repository);

  Future<Map<String, dynamic>> call({
    List<int>? bookingIds,
    List<int>? voucherIds,
  }) async {
    return await repository.removeAssignment(
      bookingIds: bookingIds,
      voucherIds: voucherIds,
    );
  }
}

