import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/pickup_booking_entity.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/pickup_item_entity.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/pickup_times_entity.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/pickup_voucher_entity.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/vehicle_group_entity.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/vehicle_group_simple_entity.dart';
import 'package:the_dunes/features/pickup_times/domain/usecases/assign_vehicle_usecase.dart';
import 'package:the_dunes/features/pickup_times/domain/usecases/get_pickup_times_usecase.dart';
import 'package:the_dunes/features/pickup_times/domain/usecases/get_vehicle_groups_usecase.dart';
import 'package:the_dunes/features/pickup_times/domain/usecases/remove_assignment_usecase.dart';
import 'package:the_dunes/features/pickup_times/domain/usecases/update_assignment_usecase.dart';
import 'package:the_dunes/features/pickup_times/domain/usecases/update_booking_status_usecase.dart';
import 'package:the_dunes/features/pickup_times/domain/usecases/update_voucher_status_usecase.dart';
import 'package:the_dunes/features/pickup_times/domain/usecases/update_pickup_time_status_usecase.dart';
import 'package:the_dunes/features/pickup_times/presentation/cubit/pickup_times_state.dart';

class PickupTimesCubit extends Cubit<PickupTimesState> {
  final GetPickupTimesUseCase getPickupTimesUseCase;
  final GetVehicleGroupsUseCase getVehicleGroupsUseCase;
  final AssignVehicleUseCase assignVehicleUseCase;
  final UpdateAssignmentUseCase updateAssignmentUseCase;
  final RemoveAssignmentUseCase removeAssignmentUseCase;
  final UpdateVoucherStatusUseCase updateVoucherStatusUseCase;
  final UpdateBookingStatusUseCase updateBookingStatusUseCase;
  final UpdatePickupTimeStatusUseCase updatePickupTimeStatusUseCase;
  
  Set<String> _preservedSelectedIds = {};
  Set<String> _recentlyAddedItemIds = {};

  Set<String> get recentlyAddedItemIds => _recentlyAddedItemIds;

  PickupTimesCubit({
    required this.getPickupTimesUseCase,
    required this.getVehicleGroupsUseCase,
    required this.assignVehicleUseCase,
    required this.updateAssignmentUseCase,
    required this.removeAssignmentUseCase,
    required this.updateVoucherStatusUseCase,
    required this.updateBookingStatusUseCase,
    required this.updatePickupTimeStatusUseCase,
  }) : super(PickupTimesInitial());

  Future<void> loadPickupTimes() async {
    final currentState = state;
    if (currentState is PickupTimesLoaded) {
      _preservedSelectedIds = Set<String>.from(currentState.selectedItemIds);
    }
    
    emit(PickupTimesLoading());
    try {
      if (kDebugMode) print('[PickupTimesCubit] Loading pickup times...');
      final pickupTimes = await getPickupTimesUseCase();
      if (kDebugMode) {
        print('[PickupTimesCubit] Loaded successfully:');
        print('[PickupTimesCubit] - Vehicle Groups: ${pickupTimes.vehicleGroups.length}');
        print('[PickupTimesCubit] - Unassigned Bookings: ${pickupTimes.unassigned.bookings.length}');
        print('[PickupTimesCubit] - Unassigned Vouchers: ${pickupTimes.unassigned.vouchers.length}');
        print('[PickupTimesCubit] - All Items: ${pickupTimes.allItems.length}');
      }
      
      final previousState = state;
      final currentPage = previousState is PickupTimesLoaded ? previousState.currentPage : 1;
      final pageSize = previousState is PickupTimesLoaded ? previousState.pageSize : 20;
      
      emit(PickupTimesLoaded(
        pickupTimes: pickupTimes,
        currentPage: currentPage,
        pageSize: pageSize,
        selectedItemIds: _preservedSelectedIds,
      ));
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('[PickupTimesCubit] Error loading pickup times: $e');
        print('[PickupTimesCubit] Stack trace: $stackTrace');
      }
      emit(PickupTimesError(e.toString()));
    }
  }

  void toggleItemSelection(String itemId) {
    final currentState = state;
    if (currentState is PickupTimesLoaded) {
      final selectedIds = Set<String>.from(currentState.selectedItemIds);
      if (selectedIds.contains(itemId)) {
        selectedIds.remove(itemId);
      } else {
        selectedIds.add(itemId);
      }
      emit(currentState.copyWith(selectedItemIds: selectedIds));
    }
  }

  void clearSelection() {
    final currentState = state;
    if (currentState is PickupTimesLoaded) {
      emit(currentState.copyWith(selectedItemIds: {}));
    }
  }

  void setPage(int page) {
    final currentState = state;
    if (currentState is PickupTimesLoaded) {
      emit(currentState.copyWith(currentPage: page));
    }
  }

  void setPageSize(int size) {
    final currentState = state;
    if (currentState is PickupTimesLoaded) {
      emit(currentState.copyWith(pageSize: size, currentPage: 1));
    }
  }

  Future<void> assignVehicle({
    required int carNumber,
    String? driver,
    List<int>? bookingIds,
    List<int>? voucherIds,
  }) async {
    try {
      // حفظ IDs العناصر المضافة قبل إرسال الطلب
      if (bookingIds != null || voucherIds != null) {
        _recentlyAddedItemIds.clear();
        if (bookingIds != null) {
          for (final id in bookingIds) {
            _recentlyAddedItemIds.add('booking_$id');
          }
        }
        if (voucherIds != null) {
          for (final id in voucherIds) {
            _recentlyAddedItemIds.add('voucher_$id');
          }
        }
      }
      
      await assignVehicleUseCase(
        carNumber: carNumber,
        driver: driver,
        bookingIds: bookingIds,
        voucherIds: voucherIds,
      );
      emit(PickupTimesSuccess('pickup_times.assign_success'));
      await loadPickupTimes();
      
      // مسح IDs بعد إعادة التحميل
      _recentlyAddedItemIds.clear();
    } catch (e) {
      emit(PickupTimesError('pickup_times.assign_error'));
    }
  }

  Future<void> updateAssignment({
    required String pickupGroupId,
    int? carNumber,
    String? driver,
    List<int>? addBookingIds,
    List<int>? addVoucherIds,
    List<int>? removeBookingIds,
    List<int>? removeVoucherIds,
  }) async {
    try {
      final currentState = state;
      if (currentState is PickupTimesLoaded) {
        // التحقق من وجود المجموعة
        currentState.pickupTimes.vehicleGroups
            .firstWhere(
              (g) => g.pickupGroupId == pickupGroupId,
              orElse: () => throw Exception('Group not found'),
            );
        
        // تم إلغاء شرط التحقق من العناصر المكررة للسماح بدمج المجموعات
      }
      
      // حفظ IDs العناصر المضافة قبل إرسال الطلب
      if (addBookingIds != null || addVoucherIds != null) {
        _recentlyAddedItemIds.clear();
        if (addBookingIds != null) {
          for (final id in addBookingIds) {
            _recentlyAddedItemIds.add('booking_$id');
          }
        }
        if (addVoucherIds != null) {
          for (final id in addVoucherIds) {
            _recentlyAddedItemIds.add('voucher_$id');
          }
        }
      }
      
      await updateAssignmentUseCase(
        pickupGroupId: pickupGroupId,
        carNumber: carNumber,
        driver: driver,
        addBookingIds: addBookingIds,
        addVoucherIds: addVoucherIds,
        removeBookingIds: removeBookingIds,
        removeVoucherIds: removeVoucherIds,
      );
      emit(PickupTimesSuccess('pickup_times.update_success'));
      await loadPickupTimes();
      
      // مسح IDs بعد إعادة التحميل
      _recentlyAddedItemIds.clear();
    } catch (e) {
      if (kDebugMode) {
        print('[PickupTimesCubit] Error in updateAssignment: $e');
      }
      if (e.toString().contains('Group not found')) {
        emit(PickupTimesError('pickup_times.update_error'));
      } else {
        final errorMessage = e.toString();
        if (errorMessage.contains('carNumber is required')) {
          emit(PickupTimesError('pickup_times.car_number_required'));
        } else {
          emit(PickupTimesError('pickup_times.update_error'));
        }
      }
    }
  }

  Future<void> removeAssignment({
    List<int>? bookingIds,
    List<int>? voucherIds,
  }) async {
    try {
      await removeAssignmentUseCase(
        bookingIds: bookingIds,
        voucherIds: voucherIds,
      );
      emit(PickupTimesSuccess('pickup_times.remove_success'));
      await loadPickupTimes();
    } catch (e) {
      emit(PickupTimesError('pickup_times.remove_error'));
    }
  }

  Future<void> updateVoucherStatus({
    required int voucherId,
    String? status,
    String? pickupStatus,
  }) async {
    try {
      await updateVoucherStatusUseCase(
        voucherId: voucherId,
        status: status,
        pickupStatus: pickupStatus,
      );
      await loadPickupTimes();
    } catch (e) {
      emit(PickupTimesError('pickup_times.update_error'));
    }
  }

  Future<void> updateBookingStatus({
    required int bookingId,
    String? status,
    String? pickupStatus,
  }) async {
    try {
      await updateBookingStatusUseCase(
        bookingId: bookingId,
        status: status,
        pickupStatus: pickupStatus,
      );
      await loadPickupTimes();
    } catch (e) {
      emit(PickupTimesError('pickup_times.update_error'));
    }
  }

  /// Update status using the new pickup-time endpoint
  /// This method automatically detects the type (booking or voucher) and updates accordingly
  /// Only updates the specific item's status without reloading the entire page
  Future<void> updateStatusFromPickupTime({
    required int id,
    required String type, // 'booking' or 'voucher'
    required String status, // Status value (PENDING, ACCEPTED, etc.)
    required String statusType, // 'bookingStatus' or 'pickupStatus'
  }) async {
    try {
      if (kDebugMode) {
        print('[PickupTimesCubit] Updating status via pickup-time endpoint');
        print('[PickupTimesCubit] ID: $id, Type: $type, Status: $status, StatusType: $statusType');
      }
      
      // First, update the status in the API
      await updatePickupTimeStatusUseCase(
        id: id,
        type: type,
        status: status,
        statusType: statusType,
      );
      
      // Then, update only the specific item in the state (without reloading)
      // If status is COMPLETED or CANCELLED, remove the item from the list
      final shouldRemove = statusType == 'bookingStatus' && 
          (status.toUpperCase() == 'COMPLETED' || status.toUpperCase() == 'CANCELLED');
      
      if (shouldRemove) {
        _removeItemFromState(id: id, type: type);
        if (kDebugMode) {
          print('[PickupTimesCubit] Status is COMPLETED or CANCELLED, item removed from state');
        }
      } else {
        _updateItemStatusInState(id: id, type: type, status: status, statusType: statusType);
        if (kDebugMode) {
          print('[PickupTimesCubit] Status updated successfully, item updated in state');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('[PickupTimesCubit] Error updating status: $e');
      }
      emit(PickupTimesError('pickup_times.update_error'));
    }
  }

  /// Update the status of a specific item in the current state
  /// This avoids reloading the entire page
  void _updateItemStatusInState({
    required int id,
    required String type,
    required String status,
    required String statusType,
  }) {
    final currentState = state;
    if (currentState is! PickupTimesLoaded) return;

    final pickupTimes = currentState.pickupTimes;
    
    // Update in vehicle groups
    final updatedVehicleGroups = pickupTimes.vehicleGroups.map((group) {
      final updatedBookings = group.bookings.map((booking) {
        if (booking.id == id && type == 'booking') {
          if (statusType == 'bookingStatus') {
            return PickupBookingEntity(
              id: booking.id,
              type: booking.type,
              guestName: booking.guestName,
              phoneNumber: booking.phoneNumber,
              payment: booking.payment,
              statusBook: status,
              pickupStatus: booking.pickupStatus,
              pickupTime: booking.pickupTime,
              services: booking.services,
              room: booking.room,
              agentId: booking.agentId,
              agentName: booking.agentName,
              location: booking.location,
              locationName: booking.locationName,
              hotelName: booking.hotelName,
              driver: booking.driver,
              carNumber: booking.carNumber,
              pickupGroupId: booking.pickupGroupId,
            );
          } else if (statusType == 'pickupStatus') {
            return PickupBookingEntity(
              id: booking.id,
              type: booking.type,
              guestName: booking.guestName,
              phoneNumber: booking.phoneNumber,
              payment: booking.payment,
              statusBook: booking.statusBook,
              pickupStatus: status,
              pickupTime: booking.pickupTime,
              services: booking.services,
              room: booking.room,
              agentId: booking.agentId,
              agentName: booking.agentName,
              location: booking.location,
              locationName: booking.locationName,
              hotelName: booking.hotelName,
              driver: booking.driver,
              carNumber: booking.carNumber,
              pickupGroupId: booking.pickupGroupId,
            );
          }
        }
        return booking;
      }).toList();
      
      final updatedVouchers = group.vouchers.map((voucher) {
        if (voucher.id == id && type == 'voucher') {
          if (statusType == 'bookingStatus') {
            return PickupVoucherEntity(
              id: voucher.id,
              type: voucher.type,
              guestName: voucher.guestName,
              phoneNumber: voucher.phoneNumber,
              payment: voucher.payment,
              status: status,
              pickupStatus: voucher.pickupStatus,
              pickupTime: voucher.pickupTime,
              services: voucher.services,
              room: voucher.room,
              agentName: voucher.agentName,
              location: voucher.location,
              locationName: voucher.locationName,
              hotel: voucher.hotel,
              driver: voucher.driver,
              carNumber: voucher.carNumber,
              pickupGroupId: voucher.pickupGroupId,
            );
          } else if (statusType == 'pickupStatus') {
            return PickupVoucherEntity(
              id: voucher.id,
              type: voucher.type,
              guestName: voucher.guestName,
              phoneNumber: voucher.phoneNumber,
              payment: voucher.payment,
              status: voucher.status,
              pickupStatus: status,
              pickupTime: voucher.pickupTime,
              services: voucher.services,
              room: voucher.room,
              agentName: voucher.agentName,
              location: voucher.location,
              locationName: voucher.locationName,
              hotel: voucher.hotel,
              driver: voucher.driver,
              carNumber: voucher.carNumber,
              pickupGroupId: voucher.pickupGroupId,
            );
          }
        }
        return voucher;
      }).toList();
      
      return VehicleGroupEntity(
        pickupGroupId: group.pickupGroupId,
        carNumber: group.carNumber,
        driver: group.driver,
        bookings: updatedBookings,
        vouchers: updatedVouchers,
        totalItems: group.totalItems,
      );
    }).toList();
    
    // Update in unassigned items
    final updatedUnassignedBookings = pickupTimes.unassigned.bookings.map((booking) {
      if (booking.id == id && type == 'booking') {
        if (statusType == 'bookingStatus') {
          return PickupBookingEntity(
            id: booking.id,
            type: booking.type,
            guestName: booking.guestName,
            phoneNumber: booking.phoneNumber,
            payment: booking.payment,
            statusBook: status,
            pickupStatus: booking.pickupStatus,
            pickupTime: booking.pickupTime,
            services: booking.services,
            room: booking.room,
            agentId: booking.agentId,
            agentName: booking.agentName,
            location: booking.location,
            locationName: booking.locationName,
            hotelName: booking.hotelName,
            driver: booking.driver,
            carNumber: booking.carNumber,
            pickupGroupId: booking.pickupGroupId,
          );
        } else if (statusType == 'pickupStatus') {
          return PickupBookingEntity(
            id: booking.id,
            type: booking.type,
            guestName: booking.guestName,
            phoneNumber: booking.phoneNumber,
            payment: booking.payment,
            statusBook: booking.statusBook,
            pickupStatus: status,
            pickupTime: booking.pickupTime,
            services: booking.services,
            room: booking.room,
            agentId: booking.agentId,
            agentName: booking.agentName,
            location: booking.location,
            locationName: booking.locationName,
            hotelName: booking.hotelName,
            driver: booking.driver,
            carNumber: booking.carNumber,
            pickupGroupId: booking.pickupGroupId,
          );
        }
      }
      return booking;
    }).toList();
    
    final updatedUnassignedVouchers = pickupTimes.unassigned.vouchers.map((voucher) {
      if (voucher.id == id && type == 'voucher') {
        if (statusType == 'bookingStatus') {
          return PickupVoucherEntity(
            id: voucher.id,
            type: voucher.type,
            guestName: voucher.guestName,
            phoneNumber: voucher.phoneNumber,
            payment: voucher.payment,
            status: status,
            pickupStatus: voucher.pickupStatus,
            pickupTime: voucher.pickupTime,
            services: voucher.services,
            room: voucher.room,
            agentName: voucher.agentName,
            location: voucher.location,
            locationName: voucher.locationName,
            hotel: voucher.hotel,
            driver: voucher.driver,
            carNumber: voucher.carNumber,
            pickupGroupId: voucher.pickupGroupId,
          );
        } else if (statusType == 'pickupStatus') {
          return PickupVoucherEntity(
            id: voucher.id,
            type: voucher.type,
            guestName: voucher.guestName,
            phoneNumber: voucher.phoneNumber,
            payment: voucher.payment,
            status: voucher.status,
            pickupStatus: status,
            pickupTime: voucher.pickupTime,
            services: voucher.services,
            room: voucher.room,
            agentName: voucher.agentName,
            location: voucher.location,
            locationName: voucher.locationName,
            hotel: voucher.hotel,
            driver: voucher.driver,
            carNumber: voucher.carNumber,
            pickupGroupId: voucher.pickupGroupId,
          );
        }
      }
      return voucher;
    }).toList();
    
    final updatedUnassigned = UnassignedItemsEntity(
      bookings: updatedUnassignedBookings,
      vouchers: updatedUnassignedVouchers,
    );
    
    // Update allItems
    final updatedAllItems = pickupTimes.allItems.map((item) {
      if (item.type == 'booking' && item.booking?.id == id && type == 'booking') {
        final booking = item.booking!;
        if (statusType == 'bookingStatus') {
          return PickupItemEntity(
            type: 'booking',
            booking: PickupBookingEntity(
              id: booking.id,
              type: booking.type,
              guestName: booking.guestName,
              phoneNumber: booking.phoneNumber,
              payment: booking.payment,
              statusBook: status,
              pickupStatus: booking.pickupStatus,
              pickupTime: booking.pickupTime,
              services: booking.services,
              room: booking.room,
              agentId: booking.agentId,
              agentName: booking.agentName,
              location: booking.location,
              locationName: booking.locationName,
              hotelName: booking.hotelName,
              driver: booking.driver,
              carNumber: booking.carNumber,
              pickupGroupId: booking.pickupGroupId,
            ),
          );
        } else if (statusType == 'pickupStatus') {
          return PickupItemEntity(
            type: 'booking',
            booking: PickupBookingEntity(
              id: booking.id,
              type: booking.type,
              guestName: booking.guestName,
              phoneNumber: booking.phoneNumber,
              payment: booking.payment,
              statusBook: booking.statusBook,
              pickupStatus: status,
              pickupTime: booking.pickupTime,
              services: booking.services,
              room: booking.room,
              agentId: booking.agentId,
              agentName: booking.agentName,
              location: booking.location,
              locationName: booking.locationName,
              hotelName: booking.hotelName,
              driver: booking.driver,
              carNumber: booking.carNumber,
              pickupGroupId: booking.pickupGroupId,
            ),
          );
        }
      } else if (item.type == 'voucher' && item.voucher?.id == id && type == 'voucher') {
        final voucher = item.voucher!;
        if (statusType == 'bookingStatus') {
          return PickupItemEntity(
            type: 'voucher',
            voucher: PickupVoucherEntity(
              id: voucher.id,
              type: voucher.type,
              guestName: voucher.guestName,
              phoneNumber: voucher.phoneNumber,
              payment: voucher.payment,
              status: status,
              pickupStatus: voucher.pickupStatus,
              pickupTime: voucher.pickupTime,
              services: voucher.services,
              room: voucher.room,
              agentName: voucher.agentName,
              location: voucher.location,
              locationName: voucher.locationName,
              hotel: voucher.hotel,
              driver: voucher.driver,
              carNumber: voucher.carNumber,
              pickupGroupId: voucher.pickupGroupId,
            ),
          );
        } else if (statusType == 'pickupStatus') {
          return PickupItemEntity(
            type: 'voucher',
            voucher: PickupVoucherEntity(
              id: voucher.id,
              type: voucher.type,
              guestName: voucher.guestName,
              phoneNumber: voucher.phoneNumber,
              payment: voucher.payment,
              status: voucher.status,
              pickupStatus: status,
              pickupTime: voucher.pickupTime,
              services: voucher.services,
              room: voucher.room,
              agentName: voucher.agentName,
              location: voucher.location,
              locationName: voucher.locationName,
              hotel: voucher.hotel,
              driver: voucher.driver,
              carNumber: voucher.carNumber,
              pickupGroupId: voucher.pickupGroupId,
            ),
          );
        }
      }
      return item;
    }).toList();
    
    final updatedPickupTimes = PickupTimesEntity(
      vehicleGroups: updatedVehicleGroups,
      unassigned: updatedUnassigned,
      allItems: updatedAllItems,
    );
    
    emit(currentState.copyWith(pickupTimes: updatedPickupTimes));
    
    if (kDebugMode) {
      print('[PickupTimesCubit] Item status updated in state: ID=$id, Type=$type, Status=$status, StatusType=$statusType');
    }
  }

  /// Remove item from state when status is COMPLETED or CANCELLED
  void _removeItemFromState({
    required int id,
    required String type,
  }) {
    final currentState = state;
    if (currentState is! PickupTimesLoaded) return;

    final pickupTimes = currentState.pickupTimes;
    
    // Remove from vehicle groups
    final updatedVehicleGroups = pickupTimes.vehicleGroups.map((group) {
      final updatedBookings = group.bookings.where((booking) {
        return !(booking.id == id && type == 'booking');
      }).toList();
      
      final updatedVouchers = group.vouchers.where((voucher) {
        return !(voucher.id == id && type == 'voucher');
      }).toList();
      
      // Recalculate totalItems
      final newTotalItems = updatedBookings.length + updatedVouchers.length;
      
      return VehicleGroupEntity(
        pickupGroupId: group.pickupGroupId,
        carNumber: group.carNumber,
        driver: group.driver,
        bookings: updatedBookings,
        vouchers: updatedVouchers,
        totalItems: newTotalItems,
      );
    }).where((group) {
      // Remove empty groups
      return group.bookings.isNotEmpty || group.vouchers.isNotEmpty;
    }).toList();
    
    // Remove from unassigned items
    final updatedUnassignedBookings = pickupTimes.unassigned.bookings.where((booking) {
      return !(booking.id == id && type == 'booking');
    }).toList();
    
    final updatedUnassignedVouchers = pickupTimes.unassigned.vouchers.where((voucher) {
      return !(voucher.id == id && type == 'voucher');
    }).toList();
    
    final updatedUnassigned = UnassignedItemsEntity(
      bookings: updatedUnassignedBookings,
      vouchers: updatedUnassignedVouchers,
    );
    
    // Remove from allItems
    final updatedAllItems = pickupTimes.allItems.where((item) {
      if (item.type == 'booking' && item.booking?.id == id && type == 'booking') {
        return false;
      }
      if (item.type == 'voucher' && item.voucher?.id == id && type == 'voucher') {
        return false;
      }
      return true;
    }).toList();
    
    final updatedPickupTimes = PickupTimesEntity(
      vehicleGroups: updatedVehicleGroups,
      unassigned: updatedUnassigned,
      allItems: updatedAllItems,
    );
    
    emit(currentState.copyWith(pickupTimes: updatedPickupTimes));
    
    if (kDebugMode) {
      print('[PickupTimesCubit] Item removed from state: ID=$id, Type=$type');
      print('[PickupTimesCubit] Remaining items: ${updatedAllItems.length}');
    }
  }

  Future<List<VehicleGroupSimpleEntity>> getVehicleGroups() async {
    try {
      if (kDebugMode) print('[PickupTimesCubit] Loading vehicle groups...');
      final groups = await getVehicleGroupsUseCase();
      if (kDebugMode) {
        print('[PickupTimesCubit] Loaded ${groups.length} vehicle groups');
      }
      return groups;
    } catch (e) {
      if (kDebugMode) {
        print('[PickupTimesCubit] Error loading vehicle groups: $e');
      }
      return [];
    }
  }
}

