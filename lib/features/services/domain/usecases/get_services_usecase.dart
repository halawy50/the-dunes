import 'package:the_dunes/features/services/domain/entities/service_entity.dart';
import 'package:the_dunes/features/services/domain/repositories/service_repository.dart';

class GetServicesUseCase {
  final ServiceRepository repository;

  GetServicesUseCase(this.repository);

  Future<List<ServiceEntity>> call() {
    return repository.getAllServices();
  }
}


