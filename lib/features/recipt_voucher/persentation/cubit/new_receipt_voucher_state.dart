part of 'new_receipt_voucher_cubit.dart';

abstract class NewReceiptVoucherState extends Equatable {
  const NewReceiptVoucherState();

  @override
  List<Object?> get props => [];
}

class NewReceiptVoucherInitial extends NewReceiptVoucherState {}

class NewReceiptVoucherLoading extends NewReceiptVoucherState {}

class NewReceiptVoucherLoaded extends NewReceiptVoucherState {
  final int servicesCount;
  final DateTime timestamp;
  
  NewReceiptVoucherLoaded({
    this.servicesCount = 0,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
  
  @override
  List<Object?> get props => [servicesCount, timestamp];
}

class NewReceiptVoucherAddingService extends NewReceiptVoucherState {}

class NewReceiptVoucherSaving extends NewReceiptVoucherState {}

class NewReceiptVoucherSaved extends NewReceiptVoucherState {}

class NewReceiptVoucherError extends NewReceiptVoucherState {
  final String message;
  const NewReceiptVoucherError(this.message);
  @override
  List<Object?> get props => [message];
}

