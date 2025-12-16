import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_dunes/core/data/models/paginated_response.dart';
import 'package:the_dunes/core/data/models/pagination_info.dart';
import 'package:the_dunes/features/recipt_voucher/data/datasources/receipt_voucher_remote_data_source.dart';
import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_model.dart';
import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_filter_model.dart';
import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_statistics_model.dart';

part 'receipt_voucher_state.dart';

class ReceiptVoucherCubit extends Cubit<ReceiptVoucherState> {
  final ReceiptVoucherRemoteDataSource remoteDataSource;

  ReceiptVoucherCubit(this.remoteDataSource) : super(ReceiptVoucherInitial());

  List<ReceiptVoucherModel> _allVouchers = [];
  PaginatedResponse<ReceiptVoucherModel>? _vouchers;
  int _currentPage = 1;
  int _pageSize = 50;
  bool _hasMore = true;
  ReceiptVoucherFilterModel? _currentFilter;
  Map<int, String> _updatingVouchers = {};
  int? _deletingVoucherId;
  Map<String, List<ReceiptVoucherModel>> _pageCache = {};
  Map<String, PaginatedResponse<ReceiptVoucherModel>> _pageResponseCache = {};

  List<ReceiptVoucherModel> get allVouchers => _allVouchers;
  PaginatedResponse<ReceiptVoucherModel>? get vouchers => _vouchers;
  int get currentPage => _currentPage;
  int get pageSize => _pageSize;
  bool get hasMore => _hasMore;
  ReceiptVoucherFilterModel? get currentFilter => _currentFilter;
  double? get totalPrice => _vouchers?.totalPrice;
  int? get totalCount => _vouchers?.totalCount;
  int get totalPages => _vouchers?.pagination.totalPages ?? 1;
  ReceiptVoucherStatisticsModel? get statistics {
    if (_vouchers?.statistics == null) {
      if (kDebugMode) {
        print('[ReceiptVoucherCubit] Statistics is null in _vouchers');
      }
      return null;
    }
    try {
      final stats = ReceiptVoucherStatisticsModel.fromJson(_vouchers!.statistics!);
      if (kDebugMode) {
        print('[ReceiptVoucherCubit] Statistics parsed successfully: total=${stats.total}, completed=${stats.completed}, pending=${stats.pending}, accepted=${stats.accepted}, cancelled=${stats.cancelled}');
      }
      return stats;
    } catch (e) {
      if (kDebugMode) {
        print('[ReceiptVoucherCubit] Error parsing statistics: $e');
        print('[ReceiptVoucherCubit] Statistics data: ${_vouchers!.statistics}');
      }
      return null;
    }
  }

  Future<void> init() async {
    await loadReceiptVouchers();
  }

  Future<void> loadReceiptVouchers({
    int? employeeId,
    int page = 1,
    ReceiptVoucherFilterModel? filter,
    bool forceRefresh = false,
  }) async {
    final cacheKey = _getCacheKey(page, filter);
    if (!forceRefresh && _pageCache.containsKey(cacheKey)) {
      _currentPage = page;
      _currentFilter = filter;
      _allVouchers = List.from(_pageCache[cacheKey]!);
      _vouchers = _pageResponseCache[cacheKey];
      _hasMore = _vouchers?.pagination.hasNext ?? false;
      if (!isClosed) {
        emit(ReceiptVoucherPageChanged(page));
      }
      return;
    }
    
    if (!isClosed) {
      emit(ReceiptVoucherLoading());
    }
    try {
      _currentPage = page;
      _currentFilter = filter;
      final response = await remoteDataSource.getReceiptVouchers(
        employeeId: employeeId,
        page: page,
        pageSize: _pageSize,
        filter: filter,
      );
      _vouchers = response;
      _allVouchers = List.from(response.data);
      _hasMore = response.pagination.hasNext;
      
      if (kDebugMode) {
        print('[ReceiptVoucherCubit] Parsed vouchers count: ${_allVouchers.length}');
        print('[ReceiptVoucherCubit] TotalPrice: ${response.totalPrice}');
        print('[ReceiptVoucherCubit] TotalCount: ${response.totalCount}');
        print('[ReceiptVoucherCubit] Statistics: ${response.statistics}');
        if (response.statistics != null) {
          final stats = statistics;
          print('[ReceiptVoucherCubit] Parsed statistics: total=${stats?.total}, completed=${stats?.completed}, pending=${stats?.pending}, accepted=${stats?.accepted}, cancelled=${stats?.cancelled}');
        } else {
          print('[ReceiptVoucherCubit] Statistics is NULL');
        }
      }
      
      _pageCache[cacheKey] = List.from(response.data);
      _pageResponseCache[cacheKey] = response;
      
      if (!isClosed) {
        emit(ReceiptVoucherSuccess(showSnackbar: filter != null, timestamp: DateTime.now()));
      }
    } catch (e) {
      if (!isClosed) {
        emit(ReceiptVoucherError(e.toString()));
      }
    }
  }

  String _getCacheKey(int page, ReceiptVoucherFilterModel? filter) {
    final filterKey = filter?.toQueryParams().toString() ?? 'no_filter';
    return '${page}_$filterKey';
  }

  Future<void> goToPage(int page, {int? employeeId, bool forceRefresh = false}) async {
    if (page < 1 || (_vouchers != null && page > _vouchers!.pagination.totalPages)) {
      return;
    }
    await loadReceiptVouchers(
      employeeId: employeeId,
      page: page,
      filter: _currentFilter,
      forceRefresh: forceRefresh,
    );
  }

  Future<void> goToNextPage({int? employeeId}) async {
    if (_vouchers != null && _currentPage < _vouchers!.pagination.totalPages) {
      await goToPage(_currentPage + 1, employeeId: employeeId);
    }
  }

  Future<void> goToPreviousPage({int? employeeId}) async {
    if (_currentPage > 1) {
      await goToPage(_currentPage - 1, employeeId: employeeId);
    }
  }

  Future<void> loadMore({int? employeeId}) async {
    if (_vouchers != null && _currentPage < _vouchers!.pagination.totalPages) {
      final nextPage = _currentPage + 1;
      final cacheKey = _getCacheKey(nextPage, _currentFilter);
      
      if (_pageCache.containsKey(cacheKey)) {
        _currentPage = nextPage;
        _allVouchers.addAll(_pageCache[cacheKey]!);
        _vouchers = PaginatedResponse(
          success: _vouchers!.success,
          message: _vouchers!.message,
          data: List.from(_allVouchers),
          pagination: PaginationInfo(
            currentPage: nextPage,
            pageSize: _vouchers!.pagination.pageSize,
            totalItems: _vouchers!.pagination.totalItems,
            totalPages: _vouchers!.pagination.totalPages,
            hasNext: nextPage < _vouchers!.pagination.totalPages,
            hasPrevious: nextPage > 1,
          ),
          totalPrice: _vouchers!.totalPrice,
          totalCount: _vouchers!.totalCount,
          statistics: _vouchers!.statistics,
        );
        if (!isClosed) {
          emit(ReceiptVoucherPageChanged(nextPage));
        }
        return;
      }

      try {
        final response = await remoteDataSource.getReceiptVouchers(
          employeeId: employeeId,
          page: nextPage,
          pageSize: _pageSize,
          filter: _currentFilter,
        );
        
        _currentPage = nextPage;
        _allVouchers.addAll(response.data);
        _hasMore = response.pagination.hasNext;
        
        _pageCache[cacheKey] = List.from(response.data);
        _pageResponseCache[cacheKey] = response;
        
        _vouchers = PaginatedResponse(
          success: _vouchers!.success,
          message: _vouchers!.message,
          data: List.from(_allVouchers),
          pagination: PaginationInfo(
            currentPage: nextPage,
            pageSize: _vouchers!.pagination.pageSize,
            totalItems: _vouchers!.pagination.totalItems,
            totalPages: _vouchers!.pagination.totalPages,
            hasNext: _hasMore,
            hasPrevious: nextPage > 1,
          ),
          totalPrice: _vouchers!.totalPrice,
          totalCount: _vouchers!.totalCount,
          statistics: _vouchers!.statistics,
        );
        
        if (!isClosed) {
          emit(ReceiptVoucherPageChanged(nextPage));
        }
      } catch (e) {
        if (!isClosed) {
          emit(ReceiptVoucherError(e.toString()));
        }
      }
    }
  }

  Future<void> refreshReceiptVouchers() async {
    _pageCache.clear();
    _pageResponseCache.clear();
    _currentPage = 1;
    _allVouchers = [];
    _hasMore = true;
    await loadReceiptVouchers(page: 1, filter: _currentFilter, forceRefresh: true);
  }

  Future<void> applyFilter(ReceiptVoucherFilterModel filter) async {
    _pageCache.clear();
    _pageResponseCache.clear();
    _currentPage = 1;
    _allVouchers = [];
    _hasMore = true;
    await loadReceiptVouchers(page: 1, filter: filter, forceRefresh: true);
  }

  Future<void> clearFilter() async {
    if (_currentFilter == null) {
      return;
    }
    _pageCache.clear();
    _pageResponseCache.clear();
    _currentFilter = null;
    _currentPage = 1;
    _allVouchers = [];
    _hasMore = true;
    await loadReceiptVouchers(page: 1, filter: null, forceRefresh: true);
  }

  bool isUpdatingVoucher(int id, String fieldName) {
    return _updatingVouchers[id] == fieldName;
  }

  bool isDeletingVoucher(int id) {
    return _deletingVoucherId == id;
  }

  Future<void> updateReceiptVoucher(int id, Map<String, dynamic> updates) async {
    if (updates.isEmpty) {
      return;
    }
    
    final hasOnlyStatus = updates.length == 1 && updates.containsKey('status');
    final hasOnlyPickupStatus = updates.length == 1 && updates.containsKey('pickupStatus');
    
    String? fieldName;
    if (hasOnlyStatus) {
      fieldName = 'status';
    } else if (hasOnlyPickupStatus) {
      fieldName = 'pickupStatus';
    }
    
    if (fieldName != null && _updatingVouchers[id] == fieldName) return;
    
    final index = _allVouchers.indexWhere((v) => v.id == id);
    if (index == -1) return;
    
    if (_vouchers == null) {
      return;
    }
    
    final oldVoucher = _allVouchers[index];
    if (fieldName != null) {
      _updatingVouchers[id] = fieldName;
    }
    if (!isClosed) {
      emit(ReceiptVoucherUpdating(id));
    }
    
    try {
      ReceiptVoucherModel updatedVoucher;
      
      if (hasOnlyStatus) {
        final newStatus = updates['status'] as String;
        if (kDebugMode) {
          print('[ReceiptVoucherCubit] Updating status for voucher $id');
          print('[ReceiptVoucherCubit] Old status: ${oldVoucher.status}');
          print('[ReceiptVoucherCubit] New status: $newStatus');
        }
        updatedVoucher = await remoteDataSource.updateReceiptVoucherStatus(
          id,
          newStatus,
        );
        // Ensure the status matches what we sent (in case server returns different value)
        if (updatedVoucher.status.toUpperCase() != newStatus.toUpperCase()) {
          // Create a new voucher with the correct status
          updatedVoucher = ReceiptVoucherModel(
            id: updatedVoucher.id,
            createAt: updatedVoucher.createAt,
            guestName: updatedVoucher.guestName,
            location: updatedVoucher.location,
            locationId: updatedVoucher.locationId,
            currencyId: updatedVoucher.currencyId,
            phoneNumber: updatedVoucher.phoneNumber,
            status: newStatus, // Use the status we sent
            hotel: updatedVoucher.hotel,
            room: updatedVoucher.room,
            note: updatedVoucher.note,
            pickupTime: updatedVoucher.pickupTime,
            pickupStatus: updatedVoucher.pickupStatus,
            driver: updatedVoucher.driver,
            carNumber: updatedVoucher.carNumber,
            payment: updatedVoucher.payment,
            employeeAddedId: updatedVoucher.employeeAddedId,
            employeeAddedName: updatedVoucher.employeeAddedName,
            commissionEmployee: updatedVoucher.commissionEmployee,
            typeOperation: updatedVoucher.typeOperation,
            employeeIsReceivedCommission: updatedVoucher.employeeIsReceivedCommission,
            discountPercentage: updatedVoucher.discountPercentage,
            services: List.from(updatedVoucher.services),
            priceBeforePercentage: updatedVoucher.priceBeforePercentage,
            priceAfterPercentage: updatedVoucher.priceAfterPercentage,
            finalPriceWithCommissionEmployee: updatedVoucher.finalPriceWithCommissionEmployee,
            finalPriceAfterDeductingCommissionEmployee: updatedVoucher.finalPriceAfterDeductingCommissionEmployee,
          );
        }
      } else if (hasOnlyPickupStatus) {
        updatedVoucher = await remoteDataSource.updateReceiptVoucherPickupStatus(
          id,
          updates['pickupStatus'] as String,
        );
      } else {
        updatedVoucher = await remoteDataSource.updateReceiptVoucher(id, updates);
      }
      
      // Update the voucher in the list - create a completely new list
      final updatedList = List<ReceiptVoucherModel>.from(_allVouchers);
      updatedList[index] = updatedVoucher;
      _allVouchers = updatedList;
      
      if (_vouchers != null) {
        _vouchers = PaginatedResponse(
          success: _vouchers!.success,
          message: _vouchers!.message,
          data: List.from(_allVouchers),
          pagination: _vouchers!.pagination,
          totalPrice: _vouchers!.totalPrice,
          totalCount: _vouchers!.totalCount,
          statistics: _vouchers!.statistics,
        );
      }
      
      // Update cache
      final cacheKey = _getCacheKey(_currentPage, _currentFilter);
      if (_pageCache.containsKey(cacheKey)) {
        _pageCache[cacheKey] = List.from(_allVouchers);
      }
      if (_pageResponseCache.containsKey(cacheKey)) {
        _pageResponseCache[cacheKey] = _vouchers!;
      }
      
      if (fieldName != null) {
        _updatingVouchers.remove(id);
      }
      final showSnackbar = !hasOnlyStatus && !hasOnlyPickupStatus;
      if (!isClosed) {
        // Emit with a new timestamp to force rebuild
        emit(ReceiptVoucherSuccess(showSnackbar: showSnackbar, timestamp: DateTime.now()));
      }
    } catch (e) {
      _allVouchers[index] = oldVoucher;
      if (_vouchers != null) {
        _vouchers = PaginatedResponse(
          success: _vouchers!.success,
          message: _vouchers!.message,
          data: _allVouchers,
          pagination: _vouchers!.pagination,
          totalPrice: _vouchers!.totalPrice,
          totalCount: _vouchers!.totalCount,
          statistics: _vouchers!.statistics,
        );
      }
      
      // Update cache with old voucher
      final cacheKey = _getCacheKey(_currentPage, _currentFilter);
      if (_pageCache.containsKey(cacheKey)) {
        _pageCache[cacheKey] = List.from(_allVouchers);
      }
      if (_pageResponseCache.containsKey(cacheKey)) {
        _pageResponseCache[cacheKey] = _vouchers!;
      }
      
      if (fieldName != null) {
        _updatingVouchers.remove(id);
      }
      if (!isClosed) {
        emit(ReceiptVoucherError('receipt_voucher.update_error'.tr()));
      }
    }
  }

  Future<void> deleteReceiptVoucher(int id) async {
    final index = _allVouchers.indexWhere((v) => v.id == id);
    if (index == -1) return;
    
    _deletingVoucherId = id;
    if (!isClosed) {
      emit(ReceiptVoucherDeleting(id));
    }
    
    try {
      await remoteDataSource.deleteReceiptVoucher(id);
      _allVouchers.removeAt(index);
      
      final newTotalCount = (_vouchers?.totalCount ?? 0) - 1;
      final newTotalPages = _vouchers != null && _pageSize > 0
          ? ((newTotalCount + _pageSize - 1) / _pageSize).ceil()
          : _vouchers?.pagination.totalPages ?? 1;
      
      _vouchers = PaginatedResponse(
        success: _vouchers!.success,
        message: _vouchers!.message,
        data: _allVouchers,
        pagination: PaginationInfo(
          currentPage: _vouchers!.pagination.currentPage,
          pageSize: _vouchers!.pagination.pageSize,
          totalItems: newTotalCount > 0 ? newTotalCount : 0,
          totalPages: newTotalPages > 0 ? newTotalPages : 1,
          hasNext: _vouchers!.pagination.currentPage < newTotalPages,
          hasPrevious: _vouchers!.pagination.currentPage > 1,
        ),
        totalPrice: _vouchers!.totalPrice,
        totalCount: newTotalCount > 0 ? newTotalCount : 0,
      );
      
      final cacheKey = _getCacheKey(_currentPage, _currentFilter);
      if (_pageCache.containsKey(cacheKey)) {
        _pageCache[cacheKey] = _pageCache[cacheKey]!
            .where((v) => v.id != id)
            .toList();
      }
      if (_pageResponseCache.containsKey(cacheKey)) {
        final cachedResponse = _pageResponseCache[cacheKey]!;
        final cachedData = cachedResponse.data.where((v) => v.id != id).toList();
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
      
      _deletingVoucherId = null;
      if (!isClosed) {
        emit(ReceiptVoucherSuccess(showSnackbar: true, isDelete: true, timestamp: DateTime.now()));
      }
    } catch (e) {
      _deletingVoucherId = null;
      if (!isClosed) {
        emit(ReceiptVoucherError(e.toString()));
      }
    }
  }

  Future<ReceiptVoucherModel> createReceiptVoucher(ReceiptVoucherModel voucher) async {
    try {
      final created = await remoteDataSource.createReceiptVoucher(voucher);
      await refreshReceiptVouchers();
      return created;
    } catch (e) {
      if (!isClosed) {
        emit(ReceiptVoucherError(e.toString()));
      }
      rethrow;
    }
  }

  Future<String> getReceiptVoucherPdf(int id) async {
    try {
      return await remoteDataSource.getReceiptVoucherPdf(id);
    } catch (e) {
      if (!isClosed) {
        emit(ReceiptVoucherError(e.toString()));
      }
      rethrow;
    }
  }
}
