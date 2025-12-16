part of 'receipt_voucher_cubit.dart';

abstract class ReceiptVoucherState extends Equatable {
  const ReceiptVoucherState();

  @override
  List<Object?> get props => [];
}

class ReceiptVoucherInitial extends ReceiptVoucherState {}

class ReceiptVoucherLoading extends ReceiptVoucherState {}

class ReceiptVoucherPageChanged extends ReceiptVoucherState {
  final int page;
  const ReceiptVoucherPageChanged(this.page);
  @override
  List<Object?> get props => [page];
}

class ReceiptVoucherSuccess extends ReceiptVoucherState {
  final bool showSnackbar;
  final bool isDelete;
  final DateTime timestamp;
  ReceiptVoucherSuccess({
    this.showSnackbar = false,
    this.isDelete = false,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime(0);
  @override
  List<Object?> get props => [showSnackbar, isDelete, timestamp];
}

class ReceiptVoucherUpdating extends ReceiptVoucherState {
  final int id;
  const ReceiptVoucherUpdating(this.id);
  @override
  List<Object?> get props => [id];
}

class ReceiptVoucherDeleting extends ReceiptVoucherState {
  final int id;
  const ReceiptVoucherDeleting(this.id);
  @override
  List<Object?> get props => [id];
}

class ReceiptVoucherError extends ReceiptVoucherState {
  final String message;
  const ReceiptVoucherError(this.message);
  @override
  List<Object?> get props => [message];
}
