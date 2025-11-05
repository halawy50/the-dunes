import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(BookingInitial());

  // TODO: Add your use cases here
  // final BookingUseCase bookingUseCase;

  void init() {
    if (kDebugMode) print('[BookingCubit] Initialized');
    // TODO: Implement initialization logic
  }

  void reset() {
    if (kDebugMode) print('[BookingCubit] State reset');
    emit(BookingInitial());
  }
}
