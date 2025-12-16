import 'package:the_dunes/features/pickup_times/domain/repositories/pickup_times_repository.dart';

class UpdateVoucherStatusUseCase {
  final PickupTimesRepository repository;

  UpdateVoucherStatusUseCase(this.repository);

  Future<Map<String, dynamic>> call({
    required int voucherId,
    String? status,
    String? pickupStatus,
  }) async {
    return await repository.updateVoucherStatus(
      voucherId: voucherId,
      status: status,
      pickupStatus: pickupStatus,
    );
  }
}

