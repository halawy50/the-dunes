import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_dunes/core/data/models/paginated_response.dart';
import 'package:the_dunes/core/data/models/pagination_info.dart';
import 'package:the_dunes/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:the_dunes/features/booking/data/models/booking_model.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRemoteDataSource remoteDataSource;

  BookingCubit(this.remoteDataSource) : super(BookingInitial());

  List<BookingModel> _allBookings = [];
  PaginatedResponse<BookingModel>? _bookings;
  int _currentPage = 1;
  int _pageSize = 50;
  bool _hasMore = true;

  List<BookingModel> get allBookings => _allBookings;
  PaginatedResponse<BookingModel>? get bookings => _bookings;
  int get currentPage => _currentPage;
  int get pageSize => _pageSize;
  bool get hasMore => _hasMore;

  Future<void> init() async {
    await loadBookings();
  }

  Future<void> setPageSize(int size) async {
    _pageSize = size;
    _currentPage = 1;
    _allBookings = [];
    _hasMore = true;
    await loadBookings();
  }

  Future<void> loadBookings({int? employeeId, int page = 1}) async {
    emit(BookingLoading());
    try {
      _currentPage = page;
      final response = await remoteDataSource.getBookings(
        employeeId: employeeId,
        page: page,
        pageSize: _pageSize,
      );
      _bookings = response;
      _allBookings = List.from(response.data);
      _hasMore = response.pagination.hasNext;
      emit(BookingSuccess());
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> loadMoreBookings({int? employeeId}) async {
    if (!_hasMore || _bookings == null) return;
    
    emit(BookingLoadingMore());
    try {
      final nextPage = _currentPage + 1;
      final response = await remoteDataSource.getBookings(
        employeeId: employeeId,
        page: nextPage,
        pageSize: _pageSize,
      );
      
      _currentPage = nextPage;
      _allBookings.addAll(response.data);
      _hasMore = response.pagination.hasNext;
      _bookings = PaginatedResponse(
        success: response.success,
        message: response.message,
        data: _allBookings,
        pagination: PaginationInfo(
          currentPage: nextPage,
          pageSize: response.pagination.pageSize,
          totalItems: response.pagination.totalItems,
          totalPages: response.pagination.totalPages,
          hasNext: _hasMore,
          hasPrevious: response.pagination.hasPrevious,
        ),
      );
      emit(BookingSuccess());
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> refreshBookings() async {
    _currentPage = 1;
    _allBookings = [];
    _hasMore = true;
    await loadBookings(page: 1);
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
