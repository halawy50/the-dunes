import 'package:equatable/equatable.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/pickup_times_entity.dart';

abstract class PickupTimesState extends Equatable {
  const PickupTimesState();

  @override
  List<Object?> get props => [];
}

class PickupTimesInitial extends PickupTimesState {}

class PickupTimesLoading extends PickupTimesState {}

class PickupTimesLoaded extends PickupTimesState {
  final PickupTimesEntity pickupTimes;
  final int currentPage;
  final int pageSize;
  final Set<String> selectedItemIds;

  const PickupTimesLoaded({
    required this.pickupTimes,
    this.currentPage = 1,
    this.pageSize = 20,
    this.selectedItemIds = const {},
  });

  @override
  List<Object?> get props => [
        pickupTimes,
        currentPage,
        pageSize,
        selectedItemIds,
      ];

  PickupTimesLoaded copyWith({
    PickupTimesEntity? pickupTimes,
    int? currentPage,
    int? pageSize,
    Set<String>? selectedItemIds,
  }) {
    return PickupTimesLoaded(
      pickupTimes: pickupTimes ?? this.pickupTimes,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      selectedItemIds: selectedItemIds ?? this.selectedItemIds,
    );
  }
}

class PickupTimesError extends PickupTimesState {
  final String message;

  const PickupTimesError(this.message);

  @override
  List<Object?> get props => [message];
}

class PickupTimesSuccess extends PickupTimesState {
  final String message;

  const PickupTimesSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

