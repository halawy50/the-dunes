import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'camp_state.dart';

class CampCubit extends Cubit<CampState> {
  CampCubit() : super(CampInitial());

  void init() {
    if (kDebugMode) print('[CampCubit] Initialized');
  }

  void reset() {
    if (kDebugMode) print('[CampCubit] State reset');
    emit(CampInitial());
  }
}

