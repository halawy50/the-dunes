import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'operation_state.dart';

class OperationCubit extends Cubit<OperationState> {
  OperationCubit() : super(OperationInitial());

  void init() {
    if (kDebugMode) print('[OperationCubit] Initialized');
  }

  void reset() {
    if (kDebugMode) print('[OperationCubit] State reset');
    emit(OperationInitial());
  }
}

