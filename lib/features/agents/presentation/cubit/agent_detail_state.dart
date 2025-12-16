import 'package:equatable/equatable.dart';
import 'package:the_dunes/features/agents/domain/entities/agent_entity.dart';
import 'package:the_dunes/features/agents/domain/entities/agent_services_entity.dart';

abstract class AgentDetailState extends Equatable {
  const AgentDetailState();

  @override
  List<Object?> get props => [];
}

class AgentDetailInitial extends AgentDetailState {}

class AgentDetailLoading extends AgentDetailState {}

class AgentDetailLoaded extends AgentDetailState {
  final AgentEntity agent;
  final AgentServicesEntity services;

  const AgentDetailLoaded({
    required this.agent,
    required this.services,
  });

  @override
  List<Object?> get props => [agent, services];
}

class AgentDetailSuccess extends AgentDetailState {
  final String message;

  const AgentDetailSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AgentDetailError extends AgentDetailState {
  final String message;

  const AgentDetailError(this.message);

  @override
  List<Object?> get props => [message];
}


