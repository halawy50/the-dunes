import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_dunes/features/hotels/domain/entities/hotel_entity.dart';
import 'package:the_dunes/features/hotels/domain/usecases/get_hotels_usecase.dart';
import 'package:the_dunes/features/hotels/domain/usecases/create_hotel_usecase.dart';
import 'package:the_dunes/features/hotels/domain/usecases/update_hotel_usecase.dart';
import 'package:the_dunes/features/hotels/domain/usecases/delete_hotel_usecase.dart';

part 'hotel_state.dart';

class HotelCubit extends Cubit<HotelState> {
  final GetHotelsUseCase getHotelsUseCase;
  final CreateHotelUseCase createHotelUseCase;
  final UpdateHotelUseCase updateHotelUseCase;
  final DeleteHotelUseCase deleteHotelUseCase;

  HotelCubit({
    required this.getHotelsUseCase,
    required this.createHotelUseCase,
    required this.updateHotelUseCase,
    required this.deleteHotelUseCase,
  }) : super(HotelInitial());

  int get currentPage {
    final state = this.state;
    if (state is HotelLoaded) {
      return state.currentPage;
    }
    return 1;
  }

  int get totalPages {
    final state = this.state;
    if (state is HotelLoaded) {
      return state.totalPages;
    }
    return 1;
  }

  void init() {
    loadHotels();
  }

  Future<void> loadHotels({int page = 1, int pageSize = 20, bool append = false}) async {
    if (!append) {
      emit(HotelLoading());
    }
    try {
      final response = await getHotelsUseCase(page: page, pageSize: pageSize);
      final currentState = state;
      if (append && currentState is HotelLoaded) {
        emit(HotelLoaded(
          hotels: [...currentState.hotels, ...response.data],
          currentPage: response.pagination.currentPage,
          totalPages: response.pagination.totalPages,
          totalItems: response.pagination.totalItems,
        ));
      } else {
        emit(HotelLoaded(
          hotels: response.data,
          currentPage: response.pagination.currentPage,
          totalPages: response.pagination.totalPages,
          totalItems: response.pagination.totalItems,
        ));
      }
    } catch (e) {
      emit(HotelError(e.toString()));
    }
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is HotelLoaded) {
      if (currentState.currentPage < currentState.totalPages) {
        await loadHotels(
          page: currentState.currentPage + 1,
          append: true,
        );
      }
    }
  }

  Future<void> createHotel(String name) async {
    emit(HotelLoading());
    try {
      await createHotelUseCase(name);
      emit(HotelSuccess('hotels.create_success'.tr()));
      await loadHotels(page: currentPage);
    } catch (e) {
      emit(HotelError(e.toString()));
    }
  }

  Future<void> updateHotel(int id, String name) async {
    emit(HotelLoading());
    try {
      await updateHotelUseCase(id, name);
      emit(HotelSuccess('hotels.update_success'.tr()));
      await loadHotels(page: currentPage);
    } catch (e) {
      emit(HotelError(e.toString()));
    }
  }

  Future<void> deleteHotel(int id) async {
    emit(HotelLoading());
    try {
      await deleteHotelUseCase(id);
      emit(HotelSuccess('hotels.delete_success'.tr()));
      await loadHotels(page: currentPage);
    } catch (e) {
      emit(HotelError(e.toString()));
    }
  }

  Future<void> refreshHotels() async {
    await loadHotels(page: currentPage);
  }
}
