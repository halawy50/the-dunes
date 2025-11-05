import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'navbar_state.dart';

class NavbarCubit extends Cubit<NavbarState> {
  NavbarCubit() : super(NavbarInitial());

  // TODO: Add your use cases here
  // final NavbarUseCase navbarUseCase;

  void init() {
    if (kDebugMode) print('[NavbarCubit] Initialized');
    // TODO: Implement initialization logic
  }

  void reset() {
    if (kDebugMode) print('[NavbarCubit] State reset');
    emit(NavbarInitial());
  }
}
