import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_dunes/core/data/models/paginated_response.dart';
import 'package:the_dunes/core/data/models/pagination_info.dart';
import 'package:the_dunes/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:the_dunes/features/booking/data/models/booking_model.dart';
import 'package:the_dunes/features/booking/data/models/booking_filter_model.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRemoteDataSource remoteDataSource;

  BookingCubit(this.remoteDataSource) : super(BookingInitial());

  List<BookingModel> _allBookings = [];
  PaginatedResponse<BookingModel>? _bookings;
  int _currentPage = 1;
  int _pageSize = 50;
  bool _hasMore = true;
  BookingFilterModel? _currentFilter;
  Map<int, String> _updatingBookings = {}; // Map<bookingId, fieldName>
  int? _deletingBookingId; // ID of booking being deleted
  Map<String, List<BookingModel>> _pageCache = {}; // Map<cacheKey, List<BookingModel>>
  Map<String, PaginatedResponse<BookingModel>> _pageResponseCache = {}; // Map<cacheKey, PaginatedResponse>

  List<BookingModel> get allBookings => _allBookings;
  PaginatedResponse<BookingModel>? get bookings => _bookings;
  int get currentPage => _currentPage;
  int get pageSize => _pageSize;
  bool get hasMore => _hasMore;
  BookingFilterModel? get currentFilter => _currentFilter;
  double? get totalPrice => _bookings?.totalPrice;
  int? get totalCount => _bookings?.totalCount;

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

  Future<void> loadBookings({
    int? employeeId,
    int page = 1,
    BookingFilterModel? filter,
    bool forceRefresh = false,
  }) async {
    // التحقق من وجود البيانات في الـ cache
    final cacheKey = _getCacheKey(page, filter);
    if (!forceRefresh && _pageCache.containsKey(cacheKey)) {
      _currentPage = page;
      _currentFilter = filter;
      _allBookings = List.from(_pageCache[cacheKey]!);
      _bookings = _pageResponseCache[cacheKey];
      _hasMore = _bookings?.pagination.hasNext ?? false;
      if (!isClosed) {
        emit(BookingPageChanged(page));
      }
      return;
    }
    
    if (!isClosed) {
      emit(BookingLoading());
    }
    try {
      _currentPage = page;
      _currentFilter = filter;
      final response = await remoteDataSource.getBookings(
        employeeId: employeeId,
        page: page,
        pageSize: _pageSize,
        filter: filter,
      );
      _bookings = response;
      _allBookings = List.from(response.data);
      _hasMore = response.pagination.hasNext;
      
      // Debug: Log parsed data
      if (kDebugMode) {
        print('[BookingCubit] Parsed bookings count: ${_allBookings.length}');
        print('[BookingCubit] TotalPrice: ${response.totalPrice}');
        print('[BookingCubit] TotalCount: ${response.totalCount}');
        print('[BookingCubit] Pagination: ${response.pagination.totalItems} items, ${response.pagination.totalPages} pages');
      }
      
      // حفظ البيانات في الـ cache
      _pageCache[cacheKey] = List.from(response.data);
      _pageResponseCache[cacheKey] = response;
      
      if (!isClosed) {
        emit(BookingSuccess(showSnackbar: filter != null, timestamp: DateTime.now()));
      }
    } catch (e) {
      if (!isClosed) {
        emit(BookingError(e.toString()));
      }
    }
  }

  String _getCacheKey(int page, BookingFilterModel? filter) {
    // إنشاء مفتاح فريد للصفحة والفلتر
    final filterKey = filter?.toQueryParams().toString() ?? 'no_filter';
    return '${page}_$filterKey';
  }

  Future<void> goToPage(int page, {int? employeeId, bool forceRefresh = false}) async {
    if (page < 1 || (_bookings != null && page > _bookings!.pagination.totalPages)) {
      return;
    }
    
    await loadBookings(
      employeeId: employeeId,
      page: page,
      filter: _currentFilter,
      forceRefresh: forceRefresh,
    );
  }

  Future<void> goToNextPage({int? employeeId}) async {
    if (_bookings != null && _currentPage < _bookings!.pagination.totalPages) {
      await goToPage(_currentPage + 1, employeeId: employeeId);
    }
  }

  Future<void> loadMore({int? employeeId}) async {
    if (_bookings != null && _currentPage < _bookings!.pagination.totalPages) {
      final nextPage = _currentPage + 1;
      final cacheKey = _getCacheKey(nextPage, _currentFilter);
      
      if (_pageCache.containsKey(cacheKey)) {
        _currentPage = nextPage;
        _allBookings.addAll(_pageCache[cacheKey]!);
        _bookings = PaginatedResponse(
          success: _bookings!.success,
          message: _bookings!.message,
          data: List.from(_allBookings),
          pagination: PaginationInfo(
            currentPage: nextPage,
            pageSize: _bookings!.pagination.pageSize,
            totalItems: _bookings!.pagination.totalItems,
            totalPages: _bookings!.pagination.totalPages,
            hasNext: nextPage < _bookings!.pagination.totalPages,
            hasPrevious: nextPage > 1,
          ),
          totalPrice: _bookings!.totalPrice,
          totalCount: _bookings!.totalCount,
          statistics: _bookings!.statistics,
        );
        if (!isClosed) {
          emit(BookingSuccess(timestamp: DateTime.now()));
        }
        return;
      }

      try {
        final response = await remoteDataSource.getBookings(
          employeeId: employeeId,
          page: nextPage,
          pageSize: _pageSize,
          filter: _currentFilter,
        );
        
        _currentPage = nextPage;
        _allBookings.addAll(response.data);
        _hasMore = response.pagination.hasNext;
        
        _pageCache[cacheKey] = List.from(response.data);
        _pageResponseCache[cacheKey] = response;
        
        _bookings = PaginatedResponse(
          success: _bookings!.success,
          message: _bookings!.message,
          data: List.from(_allBookings),
          pagination: PaginationInfo(
            currentPage: nextPage,
            pageSize: _bookings!.pagination.pageSize,
            totalItems: _bookings!.pagination.totalItems,
            totalPages: _bookings!.pagination.totalPages,
            hasNext: _hasMore,
            hasPrevious: nextPage > 1,
          ),
          totalPrice: _bookings!.totalPrice,
          totalCount: _bookings!.totalCount,
          statistics: _bookings!.statistics,
        );
        
        if (!isClosed) {
          emit(BookingSuccess(timestamp: DateTime.now()));
        }
      } catch (e) {
        if (!isClosed) {
          emit(BookingError(e.toString()));
        }
      }
    }
  }

  Future<void> goToPreviousPage({int? employeeId}) async {
    if (_currentPage > 1) {
      await goToPage(_currentPage - 1, employeeId: employeeId);
    }
  }

  int get totalPages => _bookings?.pagination.totalPages ?? 1;

  Future<void> refreshBookings() async {
    // مسح الـ cache وإعادة تحميل جميع الصفحات
    _pageCache.clear();
    _pageResponseCache.clear();
    _currentPage = 1;
    _allBookings = [];
    _hasMore = true;
    await loadBookings(page: 1, filter: _currentFilter, forceRefresh: true);
  }

  Future<void> applyFilter(BookingFilterModel filter) async {
    // مسح الـ cache عند تغيير الفلتر
    _pageCache.clear();
    _pageResponseCache.clear();
    _currentPage = 1;
    _allBookings = [];
    _hasMore = true;
    await loadBookings(page: 1, filter: filter, forceRefresh: true);
  }

  Future<void> clearFilter() async {
    if (_currentFilter == null) {
      return;
    }
    // مسح الـ cache عند مسح الفلتر
    _pageCache.clear();
    _pageResponseCache.clear();
    _currentFilter = null;
    _currentPage = 1;
    _allBookings = [];
    _hasMore = true;
    await loadBookings(page: 1, filter: null, forceRefresh: true);
  }

  bool isUpdatingBooking(int id, String fieldName) {
    return _updatingBookings[id] == fieldName;
  }

  bool isDeletingBooking(int id) {
    return _deletingBookingId == id;
  }

  Future<void> updateBooking(int id, Map<String, dynamic> updates) async {
    // التحقق من وجود تحديثات
    if (updates.isEmpty) {
      return;
    }
    
    // تحديد نوع التحديث
    final hasOnlyStatusBook = updates.length == 1 && updates.containsKey('statusBook');
    final hasOnlyPickupStatus = updates.length == 1 && updates.containsKey('pickupStatus');
    
    String? fieldName;
    if (hasOnlyStatusBook) {
      fieldName = 'statusBook';
    } else if (hasOnlyPickupStatus) {
      fieldName = 'pickupStatus';
    }
    
    if (fieldName != null && _updatingBookings[id] == fieldName) return;
    
    final index = _allBookings.indexWhere((b) => b.id == id);
    if (index == -1) return;
    
    // التحقق من وجود _bookings
    if (_bookings == null) {
      return;
    }
    
    final oldBooking = _allBookings[index];
    if (fieldName != null) {
      _updatingBookings[id] = fieldName;
    }
    if (!isClosed) {
      emit(BookingUpdating(id));
    }
    
    try {
      BookingModel updatedBooking;
      
      if (hasOnlyStatusBook) {
        final newStatus = updates['statusBook'] as String;
        if (kDebugMode) {
          print('[BookingCubit] Updating status for booking $id');
          print('[BookingCubit] Old status: ${oldBooking.statusBook}');
          print('[BookingCubit] New status: $newStatus');
        }
        await remoteDataSource.updateBookingStatus(
          id,
          newStatus,
        );
        // استخدام oldBooking كأساس وتحديث statusBook فقط للحفاظ على جميع البيانات الأخرى
        updatedBooking = BookingModel(
          id: id,
          time: oldBooking.time,
          voucher: oldBooking.voucher,
          orderNumber: oldBooking.orderNumber,
          pickupTime: oldBooking.pickupTime,
          pickupStatus: oldBooking.pickupStatus,
          employeeId: oldBooking.employeeId,
          employeeName: oldBooking.employeeName,
          guestName: oldBooking.guestName,
          phoneNumber: oldBooking.phoneNumber,
          statusBook: newStatus,
          agentName: oldBooking.agentName,
          agentNameStr: oldBooking.agentNameStr,
          locationId: oldBooking.locationId,
          locationName: oldBooking.locationName,
          hotelName: oldBooking.hotelName,
          room: oldBooking.room,
          note: oldBooking.note,
          driver: oldBooking.driver,
          carNumber: oldBooking.carNumber,
          payment: oldBooking.payment,
          typeOperation: oldBooking.typeOperation,
          services: oldBooking.services,
          priceBeforePercentage: oldBooking.priceBeforePercentage,
          priceAfterPercentage: oldBooking.priceAfterPercentage,
          finalPrice: oldBooking.finalPrice,
          bookingDate: oldBooking.bookingDate,
        );
      } else if (hasOnlyPickupStatus) {
        final newPickupStatus = updates['pickupStatus'] as String;
        if (kDebugMode) {
          print('[BookingCubit] Updating pickup status for booking $id');
          print('[BookingCubit] Old pickup status: ${oldBooking.pickupStatus ?? 'YET'}');
          print('[BookingCubit] New pickup status: $newPickupStatus');
        }
        await remoteDataSource.updateBookingPickupStatus(
          id,
          newPickupStatus,
        );
        // استخدام oldBooking كأساس وتحديث pickupStatus فقط للحفاظ على جميع البيانات الأخرى
        updatedBooking = BookingModel(
          id: id,
          time: oldBooking.time,
          voucher: oldBooking.voucher,
          orderNumber: oldBooking.orderNumber,
          pickupTime: oldBooking.pickupTime,
          pickupStatus: newPickupStatus,
          employeeId: oldBooking.employeeId,
          employeeName: oldBooking.employeeName,
          guestName: oldBooking.guestName,
          phoneNumber: oldBooking.phoneNumber,
          statusBook: oldBooking.statusBook,
          agentName: oldBooking.agentName,
          agentNameStr: oldBooking.agentNameStr,
          locationId: oldBooking.locationId,
          locationName: oldBooking.locationName,
          hotelName: oldBooking.hotelName,
          room: oldBooking.room,
          note: oldBooking.note,
          driver: oldBooking.driver,
          carNumber: oldBooking.carNumber,
          payment: oldBooking.payment,
          typeOperation: oldBooking.typeOperation,
          services: oldBooking.services,
          priceBeforePercentage: oldBooking.priceBeforePercentage,
          priceAfterPercentage: oldBooking.priceAfterPercentage,
          finalPrice: oldBooking.finalPrice,
          bookingDate: oldBooking.bookingDate,
        );
      } else {
        updatedBooking = await remoteDataSource.updateBooking(id, updates);
      }
      
      // Update the booking in the list - create a completely new list
      final updatedList = List<BookingModel>.from(_allBookings);
      updatedList[index] = updatedBooking;
      _allBookings = updatedList;
      
      if (_bookings != null) {
        _bookings = PaginatedResponse(
          success: _bookings!.success,
          message: _bookings!.message,
          data: List.from(_allBookings),
          pagination: _bookings!.pagination,
          totalPrice: _bookings!.totalPrice,
          totalCount: _bookings!.totalCount,
        );
      }
      
      // Update cache
      final cacheKey = _getCacheKey(_currentPage, _currentFilter);
      if (_pageCache.containsKey(cacheKey)) {
        _pageCache[cacheKey] = List.from(_allBookings);
      }
      if (_pageResponseCache.containsKey(cacheKey)) {
        _pageResponseCache[cacheKey] = _bookings!;
      }
      
      if (fieldName != null) {
        _updatingBookings.remove(id);
      }
      final showSnackbar = !hasOnlyStatusBook && !hasOnlyPickupStatus;
      if (!isClosed) {
        // Emit with a new timestamp to force rebuild
        emit(BookingSuccess(showSnackbar: showSnackbar, timestamp: DateTime.now()));
      }
    } catch (e) {
      _allBookings[index] = oldBooking;
      if (_bookings != null) {
        _bookings = PaginatedResponse(
          success: _bookings!.success,
          message: _bookings!.message,
          data: _allBookings,
          pagination: _bookings!.pagination,
          totalPrice: _bookings!.totalPrice,
          totalCount: _bookings!.totalCount,
        );
      }
      
      // Update cache with old booking
      final cacheKey = _getCacheKey(_currentPage, _currentFilter);
      if (_pageCache.containsKey(cacheKey)) {
        _pageCache[cacheKey] = List.from(_allBookings);
      }
      if (_pageResponseCache.containsKey(cacheKey)) {
        _pageResponseCache[cacheKey] = _bookings!;
      }
      
      if (fieldName != null) {
        _updatingBookings.remove(id);
      }
      if (!isClosed) {
        emit(BookingError('booking.update_error'.tr()));
      }
    }
  }

  Future<void> deleteBooking(int id) async {
    final index = _allBookings.indexWhere((b) => b.id == id);
    if (index == -1) return;
    
    // إظهار loading للحذف
    _deletingBookingId = id;
    if (!isClosed) {
      emit(BookingDeleting(id));
    }
    
    // حذف العنصر من API
    try {
      await remoteDataSource.deleteBooking(id);
      
      // بعد نجاح الحذف من API، حذف العنصر من القائمة المحلية
      _allBookings.removeAt(index);
      
      // تحديث totalCount إذا كان موجوداً
      final newTotalCount = (_bookings?.totalCount ?? 0) - 1;
      final newTotalPages = _bookings != null && _pageSize > 0
          ? ((newTotalCount + _pageSize - 1) / _pageSize).ceil()
          : _bookings?.pagination.totalPages ?? 1;
      
      // تحديث PaginatedResponse بدون إعادة جلب البيانات
      _bookings = PaginatedResponse(
        success: _bookings!.success,
        message: _bookings!.message,
        data: _allBookings,
        pagination: PaginationInfo(
          currentPage: _bookings!.pagination.currentPage,
          pageSize: _bookings!.pagination.pageSize,
          totalItems: newTotalCount > 0 ? newTotalCount : 0,
          totalPages: newTotalPages > 0 ? newTotalPages : 1,
          hasNext: _bookings!.pagination.currentPage < newTotalPages,
          hasPrevious: _bookings!.pagination.currentPage > 1,
        ),
        totalPrice: _bookings!.totalPrice,
        totalCount: newTotalCount > 0 ? newTotalCount : 0,
      );
      
      // إزالة العنصر من الـ cache
      final cacheKey = _getCacheKey(_currentPage, _currentFilter);
      if (_pageCache.containsKey(cacheKey)) {
        _pageCache[cacheKey] = _pageCache[cacheKey]!
            .where((b) => b.id != id)
            .toList();
      }
      if (_pageResponseCache.containsKey(cacheKey)) {
        final cachedResponse = _pageResponseCache[cacheKey]!;
        final cachedData = cachedResponse.data.where((b) => b.id != id).cast<BookingModel>().toList();
        final cachedTotalCount = (cachedResponse.totalCount ?? 0) - 1;
        final cachedTotalPages = _pageSize > 0
            ? ((cachedTotalCount + _pageSize - 1) / _pageSize).ceil()
            : cachedResponse.pagination.totalPages;
        
        _pageResponseCache[cacheKey] = PaginatedResponse(
          success: cachedResponse.success,
          message: cachedResponse.message,
          data: cachedData,
          pagination: PaginationInfo(
            currentPage: cachedResponse.pagination.currentPage,
            pageSize: cachedResponse.pagination.pageSize,
            totalItems: cachedTotalCount > 0 ? cachedTotalCount : 0,
            totalPages: cachedTotalPages > 0 ? cachedTotalPages : 1,
            hasNext: cachedResponse.pagination.currentPage < cachedTotalPages,
            hasPrevious: cachedResponse.pagination.currentPage > 1,
          ),
          totalPrice: cachedResponse.totalPrice,
          totalCount: cachedTotalCount > 0 ? cachedTotalCount : 0,
        );
      }
      
      // إخفاء loading وإرسال state للتحديث مع snackbar
      _deletingBookingId = null;
      if (!isClosed) {
        emit(BookingSuccess(showSnackbar: true, isDelete: true, timestamp: DateTime.now()));
      }
    } catch (e) {
      // في حالة فشل الحذف من API، إخفاء loading وإظهار خطأ
      _deletingBookingId = null;
      if (!isClosed) {
        emit(BookingError(e.toString()));
      }
    }
  }
}
