import 'package:equatable/equatable.dart';
import 'package:the_dunes/features/agents/domain/entities/agent_entity.dart';

abstract class AgentState extends Equatable {
  const AgentState();

  @override
  List<Object?> get props => [];
}

class AgentInitial extends AgentState {}

class AgentLoading extends AgentState {}

class AgentLoaded extends AgentState {
  final List<AgentEntity> agents;

  const AgentLoaded({required this.agents});

  @override
  List<Object?> get props => [agents];
}

class AgentSuccess extends AgentState {
  final String message;
  final List<AgentEntity> agents;

  const AgentSuccess({
    required this.message,
    required this.agents,
  });

  @override
  List<Object?> get props => [message, agents];
}

class AgentError extends AgentState {
  final String message;

  const AgentError(this.message);

  @override
  List<Object?> get props => [message];
}

class AgentUpdating extends AgentState {
  final int agentId;
  final List<AgentEntity> agents;

  const AgentUpdating({
    required this.agentId,
    required this.agents,
  });

  @override
  List<Object?> get props => [agentId, agents];
}

class AgentDeleting extends AgentState {
  final int agentId;
  final List<AgentEntity> agents;

  const AgentDeleting({
    required this.agentId,
    required this.agents,
  });

  @override
  List<Object?> get props => [agentId, agents];
}


