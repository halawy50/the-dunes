import 'package:the_dunes/features/services/domain/entities/service_entity.dart';
import 'package:the_dunes/features/services/domain/repositories/service_repository.dart';

class CreateServiceUseCase {
  final ServiceRepository repository;

  CreateServiceUseCase(this.repository);

  Future<ServiceEntity> call(Map<String, dynamic> data) {
    return repository.createService(data);
  }
}


