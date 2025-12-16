import 'package:the_dunes/features/pickup_times/domain/entities/vehicle_group_simple_entity.dart';
import 'package:the_dunes/features/pickup_times/domain/repositories/pickup_times_repository.dart';

class GetVehicleGroupsUseCase {
  final PickupTimesRepository repository;

  GetVehicleGroupsUseCase(this.repository);

  Future<List<VehicleGroupSimpleEntity>> call() async {
    return await repository.getVehicleGroups();
  }
}

