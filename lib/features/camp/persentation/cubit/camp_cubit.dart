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
      final updatedBookings = currentState.data.bookings.where((b) => b.id != bookingId).toList();
      final updatedData = CampDataEntity(
        bookings: updatedBookings,
        vouchers: currentState.data.vouchers,
      );
      emit(CampLoaded(updatedData));
      Future.microtask(() => emit(CampSuccess('camp.booking_status_updated')));
      try {
        final data = await repository.getCampData();
        Future.microtask(() => emit(CampLoaded(data)));
      } catch (loadError) {
      }
    } catch (e) {
      emit(CampLoaded(currentState.data));
      Future.microtask(() => emit(CampError(e.toString())));
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

  Future<void> updateVoucherStatus(int voucherId, String status) async {
    final currentState = state;
    if (currentState is! CampLoaded) return;

    emit(CampUpdatingVoucherStatus(voucherId, status));
    try {
      await repository.updateVoucherStatus(voucherId, status);
      final updatedVouchers = currentState.data.vouchers.where((v) => v.id != voucherId).toList();
      final updatedData = CampDataEntity(
        bookings: currentState.data.bookings,
        vouchers: updatedVouchers,
      );
      emit(CampLoaded(updatedData));
      Future.microtask(() => emit(CampSuccess('camp.voucher_status_updated')));
      try {
        final data = await repository.getCampData();
        Future.microtask(() => emit(CampLoaded(data)));
      } catch (loadError) {
      }
    } catch (e) {
      emit(CampLoaded(currentState.data));
      Future.microtask(() => emit(CampError(e.toString())));
    }
  }

  bool isUpdatingVoucherStatus(int voucherId) {
    final currentState = state;
    if (currentState is CampUpdatingVoucherStatus) {
      return currentState.voucherId == voucherId;
    }
    return false;
  }

  String? getUpdatingVoucherStatus(int voucherId) {
    final currentState = state;
    if (currentState is CampUpdatingVoucherStatus) {
      if (currentState.voucherId == voucherId) {
        return currentState.status;
      }
    }
    return null;
  }

  Future<void> refreshCampData() async {
    await loadCampData();
  }
}
