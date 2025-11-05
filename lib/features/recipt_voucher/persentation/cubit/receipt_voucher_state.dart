part of 'receipt_voucher_cubit.dart';

abstract class ReceiptVoucherState extends Equatable {
  const ReceiptVoucherState();

  @override
  List<Object?> get props => [];
}

class ReceiptVoucherInitial extends ReceiptVoucherState {}

class ReceiptVoucherLoading extends ReceiptVoucherState {}

class ReceiptVoucherSuccess extends ReceiptVoucherState {
  // TODO: Add success data here
  const ReceiptVoucherSuccess();
}

class ReceiptVoucherError extends ReceiptVoucherState {
  final String message;

  const ReceiptVoucherError(this.message);

  @override
  List<Object?> get props => [message];
}
