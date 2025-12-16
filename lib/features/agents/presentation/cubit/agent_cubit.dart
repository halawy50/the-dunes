import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/features/agents/domain/usecases/get_all_agents_usecase.dart';
import 'package:the_dunes/features/agents/domain/usecases/create_agent_usecase.dart';
import 'package:the_dunes/features/agents/domain/usecases/update_agent_usecase.dart';
import 'package:the_dunes/features/agents/domain/usecases/delete_agent_usecase.dart';
import 'package:the_dunes/features/agents/presentation/cubit/agent_state.dart';

class AgentCubit extends Cubit<AgentState> {
  final GetAllAgentsUseCase getAllAgentsUseCase;
  final CreateAgentUseCase createAgentUseCase;
  final UpdateAgentUseCase updateAgentUseCase;
  final DeleteAgentUseCase deleteAgentUseCase;

  AgentCubit({
    required this.getAllAgentsUseCase,
    required this.createAgentUseCase,
    required this.updateAgentUseCase,
    required this.deleteAgentUseCase,
  }) : super(AgentInitial());

  Future<void> loadAgents() async {
    emit(AgentLoading());
    try {
      final agents = await getAllAgentsUseCase();
      emit(AgentLoaded(agents: agents));
    } catch (e) {
      emit(AgentError(e.toString()));
    }
  }

  Future<void> createAgent(String name) async {
    emit(AgentLoading());
    try {
      await createAgentUseCase(name);
      final agents = await getAllAgentsUseCase();
      emit(AgentSuccess(
        message: 'agents.create_success'.tr(),
        agents: agents,
      ));
    } catch (e) {
      emit(AgentError(e.toString()));
    }
  }

  Future<void> updateAgent(int id, String name) async {
    final currentState = state;
    if (currentState is! AgentLoaded) return;

    emit(AgentUpdating(agentId: id, agents: currentState.agents));
    try {
      await updateAgentUseCase(id, name);
      final agents = await getAllAgentsUseCase();
      emit(AgentSuccess(
        message: 'agents.update_success'.tr(),
        agents: agents,
      ));
    } catch (e) {
      emit(AgentError(e.toString()));
      emit(AgentLoaded(agents: currentState.agents));
    }
  }

  Future<void> deleteAgent(int id) async {
    final currentState = state;
    if (currentState is! AgentLoaded) return;

    emit(AgentDeleting(agentId: id, agents: currentState.agents));
    try {
      await deleteAgentUseCase(id);
      final agents = await getAllAgentsUseCase();
      emit(AgentSuccess(
        message: 'agents.delete_success'.tr(),
        agents: agents,
      ));
    } catch (e) {
      emit(AgentError(e.toString()));
      emit(AgentLoaded(agents: currentState.agents));
    }
  }

  bool isUpdatingAgent(int agentId) {
    final currentState = state;
    if (currentState is AgentUpdating) {
      return currentState.agentId == agentId;
    }
    return false;
  }

  bool isDeletingAgent(int agentId) {
    final currentState = state;
    if (currentState is AgentDeleting) {
      return currentState.agentId == agentId;
    }
    return false;
  }

  Future<void> refreshAgents() async {
    await loadAgents();
  }
}


