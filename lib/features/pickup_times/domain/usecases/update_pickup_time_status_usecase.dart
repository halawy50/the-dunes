import 'package:the_dunes/features/pickup_times/domain/repositories/pickup_times_repository.dart';

class UpdatePickupTimeStatusUseCase {
  final PickupTimesRepository repository;

  UpdatePickupTimeStatusUseCase(this.repository);

  Future<Map<String, dynamic>> call({
    required int id,
    required String type,
    required String status,
    required String statusType,
  }) async {
    return await repository.updatePickupTimeStatus(
      id: id,
      type: type,
      status: status,
      statusType: statusType,
    );
  }
}


