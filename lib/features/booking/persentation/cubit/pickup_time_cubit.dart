import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'pickup_time_state.dart';

class PickupTimeCubit extends Cubit<PickupTimeState> {
  PickupTimeCubit() : super(PickupTimeInitial());

  void init() {
    if (kDebugMode) print('[PickupTimeCubit] Initialized');
  }

  void reset() {
    if (kDebugMode) print('[PickupTimeCubit] State reset');
    emit(PickupTimeInitial());
  }
}
