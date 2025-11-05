import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryInitial());

  // TODO: Add your use cases here
  // final HistoryUseCase historyUseCase;

  void init() {
    if (kDebugMode) print('[HistoryCubit] Initialized');
    // TODO: Implement initialization logic
  }

  void reset() {
    if (kDebugMode) print('[HistoryCubit] State reset');
    emit(HistoryInitial());
  }
}
