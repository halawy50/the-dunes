import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'receipt_voucher_state.dart';

class ReceiptVoucherCubit extends Cubit<ReceiptVoucherState> {
  ReceiptVoucherCubit() : super(ReceiptVoucherInitial());

  // TODO: Add your use cases here
  // final ReceiptVoucherUseCase receiptVoucherUseCase;

  void init() {
    if (kDebugMode) print('[ReceiptVoucherCubit] Initialized');
    // TODO: Implement initialization logic
  }

  void reset() {
    if (kDebugMode) print('[ReceiptVoucherCubit] State reset');
    emit(ReceiptVoucherInitial());
  }
}
