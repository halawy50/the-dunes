import 'package:the_dunes/features/pickup_times/domain/entities/pickup_times_entity.dart';
import 'package:the_dunes/features/pickup_times/domain/repositories/pickup_times_repository.dart';

class GetPickupTimesUseCase {
  final PickupTimesRepository repository;

  GetPickupTimesUseCase(this.repository);

  Future<PickupTimesEntity> call() async {
    return await repository.getPickupTimes();
  }
}

