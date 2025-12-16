import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/features/agents/domain/usecases/get_agent_by_id_usecase.dart';
import 'package:the_dunes/features/agents/domain/usecases/get_agent_services_usecase.dart';
import 'package:the_dunes/features/agents/domain/usecases/create_agent_service_usecase.dart';
import 'package:the_dunes/features/agents/domain/usecases/update_service_agent_usecase.dart';
import 'package:the_dunes/features/agents/domain/usecases/delete_service_agent_usecase.dart';
import 'package:the_dunes/features/agents/domain/usecases/update_agent_usecase.dart';
import 'package:the_dunes/features/agents/domain/usecases/delete_agent_usecase.dart';
import 'package:the_dunes/features/agents/presentation/cubit/agent_detail_state.dart';

class AgentDetailCubit extends Cubit<AgentDetailState> {
  final GetAgentByIdUseCase getAgentByIdUseCase;
  final GetAgentServicesUseCase getAgentServicesUseCase;
  final CreateAgentServiceUseCase createAgentServiceUseCase;
  final UpdateServiceAgentUseCase updateServiceAgentUseCase;
  final DeleteServiceAgentUseCase deleteServiceAgentUseCase;
  final UpdateAgentUseCase updateAgentUseCase;
  final DeleteAgentUseCase deleteAgentUseCase;

  AgentDetailCubit({
    required this.getAgentByIdUseCase,
    required this.getAgentServicesUseCase,
    required this.createAgentServiceUseCase,
    required this.updateServiceAgentUseCase,
    required this.deleteServiceAgentUseCase,
    required this.updateAgentUseCase,
    required this.deleteAgentUseCase,
  }) : super(AgentDetailInitial());

  Future<void> loadAgentDetail(int agentId) async {
    emit(AgentDetailLoading());
    try {
      final agent = await getAgentByIdUseCase(agentId);
      final services = await getAgentServicesUseCase(agentId);
      emit(AgentDetailLoaded(agent: agent, services: services));
    } catch (e) {
      emit(AgentDetailError(e.toString()));
    }
  }

  Future<void> createService({
    required int agentId,
    required int serviceId,
    int? locationId,
    required double adultPrice,
    double? childPrice,
    double? kidPrice,
  }) async {
    emit(AgentDetailLoading());
    try {
      await createAgentServiceUseCase(
        agentId: agentId,
        serviceId: serviceId,
        locationId: locationId,
        adultPrice: adultPrice,
        childPrice: childPrice,
        kidPrice: kidPrice,
      );
      emit(AgentDetailSuccess('agents.create_service_success'.tr()));
      await loadAgentDetail(agentId);
    } catch (e) {
      emit(AgentDetailError(e.toString()));
    }
  }

  Future<void> updateService({
    required int id,
    required int agentId,
    int? locationId,
    double? adultPrice,
    double? childPrice,
    double? kidPrice,
  }) async {
    emit(AgentDetailLoading());
    try {
      await updateServiceAgentUseCase(
        id: id,
        locationId: locationId,
        adultPrice: adultPrice,
        childPrice: childPrice,
        kidPrice: kidPrice,
      );
      emit(AgentDetailSuccess('agents.update_service_success'.tr()));
      await loadAgentDetail(agentId);
    } catch (e) {
      emit(AgentDetailError(e.toString()));
    }
  }

  Future<void> deleteService({
    required int id,
    required int agentId,
  }) async {
    emit(AgentDetailLoading());
    try {
      await deleteServiceAgentUseCase(id);
      emit(AgentDetailSuccess('agents.delete_service_success'.tr()));
      await loadAgentDetail(agentId);
    } catch (e) {
      emit(AgentDetailError(e.toString()));
    }
  }

  Future<void> refreshAgentDetail(int agentId) async {
    await loadAgentDetail(agentId);
  }

  Future<void> updateAgent({
    required int agentId,
    required String name,
  }) async {
    emit(AgentDetailLoading());
    try {
      await updateAgentUseCase(agentId, name);
      emit(AgentDetailSuccess('agents.update_success'.tr()));
      await loadAgentDetail(agentId);
    } catch (e) {
      emit(AgentDetailError(e.toString()));
    }
  }

  Future<void> deleteAgent(int agentId) async {
    emit(AgentDetailLoading());
    try {
      await deleteAgentUseCase(agentId);
      emit(AgentDetailSuccess('agents.delete_success'.tr()));
    } catch (e) {
      emit(AgentDetailError(e.toString()));
    }
  }
}


