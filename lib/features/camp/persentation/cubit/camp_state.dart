part of 'camp_cubit.dart';

abstract class CampState extends Equatable {
  const CampState();

  @override
  List<Object?> get props => [];
}

class CampInitial extends CampState {}

class CampLoading extends CampState {}

class CampLoaded extends CampState {
  final CampDataEntity data;

  const CampLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class CampSuccess extends CampState {
  final String message;

  const CampSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class CampUpdatingBookingStatus extends CampState {
  final int bookingId;
  final String status;
  const CampUpdatingBookingStatus(this.bookingId, this.status);

  @override
  List<Object?> get props => [bookingId, status];
}

class CampUpdatingVoucherStatus extends CampState {
  final int voucherId;
  final String status;
  const CampUpdatingVoucherStatus(this.voucherId, this.status);

  @override
  List<Object?> get props => [voucherId, status];
}

class CampError extends CampState {
  final String message;

  const CampError(this.message);

  @override
  List<Object?> get props => [message];
}
