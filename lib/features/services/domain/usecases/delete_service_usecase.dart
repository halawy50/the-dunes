import 'package:the_dunes/features/services/domain/repositories/service_repository.dart';

class DeleteServiceUseCase {
  final ServiceRepository repository;

  DeleteServiceUseCase(this.repository);

  Future<void> call(int id) {
    return repository.deleteService(id);
  }
}


