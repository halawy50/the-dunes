part of 'camp_cubit.dart';

abstract class CampState extends Equatable {
  const CampState();

  @override
  List<Object?> get props => [];
}

class CampInitial extends CampState {}

class CampLoading extends CampState {}

class CampSuccess extends CampState {
  const CampSuccess();
}

class CampError extends CampState {
  final String message;

  const CampError(this.message);

  @override
  List<Object?> get props => [message];
}

