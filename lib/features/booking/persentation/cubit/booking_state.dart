part of 'booking_cubit.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoadingMore extends BookingState {}

class BookingSuccess extends BookingState {
  final bool showSnackbar;
  final bool isDelete;

  const BookingSuccess({this.showSnackbar = true, this.isDelete = false});
}

class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}

class BookingUpdating extends BookingState {
  final int bookingId;

  const BookingUpdating(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}

class BookingDeleting extends BookingState {
  final int bookingId;

  const BookingDeleting(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}

class BookingPageChanged extends BookingState {
  final int page;

  const BookingPageChanged(this.page);

  @override
  List<Object?> get props => [page];
}
