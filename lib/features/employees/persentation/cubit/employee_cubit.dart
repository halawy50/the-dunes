import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  EmployeeCubit() : super(EmployeeInitial());

  // TODO: Add your use cases here
  // final EmployeeUseCase employeeUseCase;

  void init() {
    if (kDebugMode) print('[EmployeeCubit] Initialized');
    // TODO: Implement initialization logic
  }

  void reset() {
    if (kDebugMode) print('[EmployeeCubit] State reset');
    emit(EmployeeInitial());
  }
}
