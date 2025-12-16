import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_dunes/features/camp/domain/entities/camp_data_entity.dart';
import 'package:the_dunes/features/camp/domain/repositories/camp_repository.dart';

part 'camp_state.dart';

class CampCubit extends Cubit<CampState> {
  final CampRepository repository;

  CampCubit(this.repository) : super(CampInitial());

  Future<void> loadCampData() async {
    emit(CampLoading());
    try {
      final data = await repository.getCampData();
      emit(CampLoaded(data));
    } catch (e) {
      emit(CampError(e.toString()));
    }
  }

  Future<void> updateBookingStatus(int bookingId, String status) async {
    final currentState = state;
    if (currentState is! CampLoaded) return;

    emit(CampUpdatingBookingStatus(bookingId, status));
    try {
      await repository.updateBookingStatus(bookingId, status);
      await loadCampData();
      emit(CampSuccess('camp.booking_status_updated'.tr()));
    } catch (e) {
      emit(CampError(e.toString()));
      emit(CampLoaded(currentState.data));
    }
  }

  bool isUpdatingBookingStatus(int bookingId) {
    final currentState = state;
    if (currentState is CampUpdatingBookingStatus) {
      return currentState.bookingId == bookingId;
    }
    return false;
  }

  String? getUpdatingStatus(int bookingId) {
    final currentState = state;
    if (currentState is CampUpdatingBookingStatus) {
      if (currentState.bookingId == bookingId) {
        return currentState.status;
      }
    }
    return null;
  }

  Future<void> refreshCampData() async {
    await loadCampData();
  }
}
