import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'hotel_state.dart';

class HotelCubit extends Cubit<HotelState> {
  HotelCubit() : super(HotelInitial());

  // TODO: Add your use cases here
  // final HotelUseCase hotelUseCase;

  void init() {
    if (kDebugMode) print('[HotelCubit] Initialized');
    // TODO: Implement initialization logic
  }

  void reset() {
    if (kDebugMode) print('[HotelCubit] State reset');
    emit(HotelInitial());
  }
}
