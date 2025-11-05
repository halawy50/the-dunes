import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  // TODO: Add your use cases here
  // final NotificationUseCase notificationUseCase;

  void init() {
    if (kDebugMode) print('[NotificationCubit] Initialized');
    // TODO: Implement initialization logic
  }

  void reset() {
    if (kDebugMode) print('[NotificationCubit] State reset');
    emit(NotificationInitial());
  }
}
