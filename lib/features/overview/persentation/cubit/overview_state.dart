part of 'overview_cubit.dart';

abstract class OverviewState extends Equatable {
  const OverviewState();

  @override
  List<Object?> get props => [];
}

class OverviewInitial extends OverviewState {}

class OverviewLoading extends OverviewState {}

class OverviewSuccess extends OverviewState {
  // TODO: Add success data here
  const OverviewSuccess();
}

class OverviewError extends OverviewState {
  final String message;

  const OverviewError(this.message);

  @override
  List<Object?> get props => [message];
}
