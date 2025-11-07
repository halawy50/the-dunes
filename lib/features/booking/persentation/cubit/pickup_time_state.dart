part of 'pickup_time_cubit.dart';

abstract class PickupTimeState extends Equatable {
  const PickupTimeState();

  @override
  List<Object?> get props => [];
}

class PickupTimeInitial extends PickupTimeState {}

class PickupTimeLoading extends PickupTimeState {}

class PickupTimeSuccess extends PickupTimeState {}

class PickupTimeError extends PickupTimeState {
  const PickupTimeError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
