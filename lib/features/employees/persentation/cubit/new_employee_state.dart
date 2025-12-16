part of 'new_employee_cubit.dart';

abstract class NewEmployeeState extends Equatable {
  const NewEmployeeState();

  @override
  List<Object?> get props => [];
}

class NewEmployeeInitial extends NewEmployeeState {}

class NewEmployeeFormUpdated extends NewEmployeeState {
  final String? updatedPermissionKey;
  
  const NewEmployeeFormUpdated({this.updatedPermissionKey});
  
  @override
  List<Object?> get props => [updatedPermissionKey];
}

class NewEmployeeLoading extends NewEmployeeState {}

class NewEmployeeSuccess extends NewEmployeeState {
  final String message;
  const NewEmployeeSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class NewEmployeeError extends NewEmployeeState {
  final String message;
  const NewEmployeeError(this.message);

  @override
  List<Object?> get props => [message];
}

