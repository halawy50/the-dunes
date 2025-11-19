part of 'new_booking_cubit.dart';

abstract class NewBookingState extends Equatable {
  const NewBookingState();

  @override
  List<Object?> get props => [];
}

class NewBookingInitial extends NewBookingState {}

class NewBookingLoading extends NewBookingState {}

class NewBookingLoaded extends NewBookingState {}

class NewBookingSaving extends NewBookingState {}

class NewBookingSaved extends NewBookingState {}

class NewBookingError extends NewBookingState {
  final String message;

  const NewBookingError(this.message);

  @override
  List<Object?> get props => [message];
}


