part of 'operation_cubit.dart';

abstract class OperationState extends Equatable {
  const OperationState();

  @override
  List<Object?> get props => [];
}

class OperationInitial extends OperationState {}

class OperationLoading extends OperationState {}

class OperationSuccess extends OperationState {
  const OperationSuccess();
}

class OperationError extends OperationState {
  final String message;

  const OperationError(this.message);

  @override
  List<Object?> get props => [message];
}

