import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'service_state.dart';

class ServiceCubit extends Cubit<ServiceState> {
  ServiceCubit() : super(ServiceInitial());

  // TODO: Add your use cases here
  // final ServiceUseCase serviceUseCase;

  void init() {
    if (kDebugMode) print('[ServiceCubit] Initialized');
    // TODO: Implement initialization logic
  }

  void reset() {
    if (kDebugMode) print('[ServiceCubit] State reset');
    emit(ServiceInitial());
  }
}
