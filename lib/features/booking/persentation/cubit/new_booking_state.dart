part of 'new_booking_cubit.dart';

abstract class NewBookingState extends Equatable {
  const NewBookingState();

  @override
  List<Object?> get props => [];
}

class NewBookingInitial extends NewBookingState {}

class NewBookingLoading extends NewBookingState {}

class NewBookingAddingRow extends NewBookingState {}

class NewBookingAddingService extends NewBookingState {
  final int rowIndex;

  const NewBookingAddingService(this.rowIndex);

  @override
  List<Object?> get props => [rowIndex];
}

class NewBookingLoaded extends NewBookingState {
  final DateTime timestamp;

  NewBookingLoaded() : timestamp = DateTime.now();

  @override
  List<Object?> get props => [timestamp];
}

class NewBookingServicesLoading extends NewBookingState {
  final int agentId;
  final int? locationId;

  const NewBookingServicesLoading({
    required this.agentId,
    this.locationId,
  });

  @override
  List<Object?> get props => [agentId, locationId];
}

class NewBookingSaving extends NewBookingState {}

class NewBookingSaved extends NewBookingState {}

class NewBookingError extends NewBookingState {
  final String message;

  const NewBookingError(this.message);

  @override
  List<Object?> get props => [message];
}


