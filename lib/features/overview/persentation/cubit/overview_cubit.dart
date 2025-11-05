import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'overview_state.dart';

class OverviewCubit extends Cubit<OverviewState> {
  OverviewCubit() : super(OverviewInitial());

  // TODO: Add your use cases here
  // final OverviewUseCase overviewUseCase;

  void init() {
    if (kDebugMode) print('[OverviewCubit] Initialized');
    // TODO: Implement initialization logic
  }

  void reset() {
    if (kDebugMode) print('[OverviewCubit] State reset');
    emit(OverviewInitial());
  }
}
