import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_dunes/core/data/models/paginated_response.dart';
import 'package:the_dunes/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:the_dunes/features/booking/data/models/booking_model.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRemoteDataSource remoteDataSource;

  BookingCubit(this.remoteDataSource) : super(BookingInitial());

  PaginatedResponse<BookingModel>? _bookings;
  int _currentPage = 1;
  final int _pageSize = 20;

  PaginatedResponse<BookingModel>? get bookings => _bookings;
  int get currentPage => _currentPage;

  Future<void> init() async {
    await loadBookings();
  }

  Future<void> loadBookings({int? employeeId, int page = 1}) async {
    emit(BookingLoading());
    try {
      _currentPage = page;
      _bookings = await remoteDataSource.getBookings(
        employeeId: employeeId,
        page: page,
        pageSize: _pageSize,
      );
      emit(BookingSuccess());
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> refreshBookings() async {
    await loadBookings(page: _currentPage);
  }

  Future<void> updateBooking(int id, Map<String, dynamic> updates) async {
    emit(BookingLoading());
    try {
      await remoteDataSource.updateBooking(id, updates);
      await refreshBookings();
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> deleteBooking(int id) async {
    emit(BookingLoading());
    try {
      await remoteDataSource.deleteBooking(id);
      await refreshBookings();
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}
