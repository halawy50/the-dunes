import 'package:the_dunes/features/services/domain/entities/service_entity.dart';

abstract class ServiceRepository {
  Future<List<ServiceEntity>> getAllServices();

  Future<ServiceEntity> getServiceById(int id);

  Future<ServiceEntity> createService(Map<String, dynamic> data);

  Future<ServiceEntity> updateService(int id, Map<String, dynamic> data);

  Future<void> deleteService(int id);
}


