import 'package:the_dunes/features/services/domain/entities/service_entity.dart';
import 'package:the_dunes/features/services/domain/repositories/service_repository.dart';

class UpdateServiceUseCase {
  final ServiceRepository repository;

  UpdateServiceUseCase(this.repository);

  Future<ServiceEntity> call(int id, Map<String, dynamic> data) {
    return repository.updateService(id, data);
  }
}


