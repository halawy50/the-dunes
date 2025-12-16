part of 'hotel_cubit.dart';

abstract class HotelState extends Equatable {
  const HotelState();

  @override
  List<Object?> get props => [];
}

class HotelInitial extends HotelState {}

class HotelLoading extends HotelState {}

class HotelLoaded extends HotelState {
  final List<HotelEntity> hotels;
  final int currentPage;
  final int totalPages;
  final int totalItems;

  const HotelLoaded({
    required this.hotels,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
  });

  @override
  List<Object?> get props => [hotels, currentPage, totalPages, totalItems];
}

class HotelSuccess extends HotelState {
  final String message;

  const HotelSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class HotelError extends HotelState {
  final String message;

  const HotelError(this.message);

  @override
  List<Object?> get props => [message];
}
