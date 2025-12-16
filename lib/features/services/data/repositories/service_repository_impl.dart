import 'package:the_dunes/features/services/data/datasources/service_remote_data_source.dart';
import 'package:the_dunes/features/services/domain/entities/service_entity.dart';
import 'package:the_dunes/features/services/domain/repositories/service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceRemoteDataSource dataSource;

  ServiceRepositoryImpl(this.dataSource);

  @override
  Future<List<ServiceEntity>> getAllServices() async {
    return await dataSource.getAllServices();
  }

  @override
  Future<ServiceEntity> getServiceById(int id) async {
    return await dataSource.getServiceById(id);
  }

  @override
  Future<ServiceEntity> createService(Map<String, dynamic> data) async {
    return await dataSource.createService(data);
  }

  @override
  Future<ServiceEntity> updateService(
    int id,
    Map<String, dynamic> data,
  ) async {
    return await dataSource.updateService(id, data);
  }

  @override
  Future<void> deleteService(int id) async {
    return await dataSource.deleteService(id);
  }
}


