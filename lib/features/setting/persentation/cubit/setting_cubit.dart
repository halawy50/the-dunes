import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit() : super(SettingInitial());

  // TODO: Add your use cases here
  // final SettingUseCase settingUseCase;

  void init() {
    if (kDebugMode) print('[SettingCubit] Initialized');
    // TODO: Implement initialization logic
  }

  void reset() {
    if (kDebugMode) print('[SettingCubit] State reset');
    emit(SettingInitial());
  }
}
