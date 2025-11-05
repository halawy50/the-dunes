part of 'setting_cubit.dart';

abstract class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object?> get props => [];
}

class SettingInitial extends SettingState {}

class SettingLoading extends SettingState {}

class SettingSuccess extends SettingState {
  // TODO: Add success data here
  const SettingSuccess();
}

class SettingError extends SettingState {
  final String message;

  const SettingError(this.message);

  @override
  List<Object?> get props => [message];
}
