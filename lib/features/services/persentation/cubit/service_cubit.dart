import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_dunes/features/services/domain/entities/service_entity.dart';
import 'package:the_dunes/features/services/domain/usecases/create_service_usecase.dart';
import 'package:the_dunes/features/services/domain/usecases/delete_service_usecase.dart';
import 'package:the_dunes/features/services/domain/usecases/get_services_usecase.dart';
import 'package:the_dunes/features/services/domain/usecases/update_service_usecase.dart';

part 'service_state.dart';

class ServiceCubit extends Cubit<ServiceState> {
  final GetServicesUseCase getServicesUseCase;
  final CreateServiceUseCase createServiceUseCase;
  final UpdateServiceUseCase updateServiceUseCase;
  final DeleteServiceUseCase deleteServiceUseCase;

  ServiceCubit({
    required this.getServicesUseCase,
    required this.createServiceUseCase,
    required this.updateServiceUseCase,
    required this.deleteServiceUseCase,
  }) : super(ServiceInitial());

  Future<void> loadServices() async {
    emit(ServiceLoading());
    try {
      final services = await getServicesUseCase();
      emit(ServiceLoaded(services));
    } catch (e) {
      emit(ServiceError(e.toString()));
    }
  }

  Future<void> createService(Map<String, dynamic> data) async {
    emit(ServiceLoading());
    try {
      await createServiceUseCase(data);
      emit(ServiceSuccess('services.create_success'.tr()));
      await loadServices();
    } catch (e) {
      emit(ServiceError(e.toString()));
    }
  }

  Future<void> updateService(int id, Map<String, dynamic> data) async {
    emit(ServiceLoading());
    try {
      await updateServiceUseCase(id, data);
      emit(ServiceSuccess('services.update_success'.tr()));
      await loadServices();
    } catch (e) {
      emit(ServiceError(e.toString()));
    }
  }

  Future<void> deleteService(int id) async {
    emit(ServiceLoading());
    try {
      await deleteServiceUseCase(id);
      emit(ServiceSuccess('services.delete_success'.tr()));
      await loadServices();
    } catch (e) {
      emit(ServiceError(e.toString()));
    }
  }

  Future<void> refreshServices() async {
    await loadServices();
  }
}
