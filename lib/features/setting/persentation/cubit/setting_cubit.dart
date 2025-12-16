import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_dunes/features/setting/domain/entities/exchange_rates_entity.dart';
import 'package:the_dunes/features/setting/domain/usecases/get_exchange_rates_usecase.dart';
import 'package:the_dunes/features/setting/domain/usecases/update_exchange_rates_usecase.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  final GetExchangeRatesUseCase getExchangeRatesUseCase;
  final UpdateExchangeRatesUseCase updateExchangeRatesUseCase;

  SettingCubit({
    required this.getExchangeRatesUseCase,
    required this.updateExchangeRatesUseCase,
  }) : super(SettingInitial());

  Future<void> init() async {
    emit(SettingLoading());
    try {
      final exchangeRates = await getExchangeRatesUseCase();
      emit(SettingLoaded(exchangeRates));
    } catch (e) {
      emit(SettingError(e.toString()));
    }
  }

  Future<void> loadExchangeRates() async {
    emit(SettingLoading());
    try {
      final exchangeRates = await getExchangeRatesUseCase();
      emit(SettingLoaded(exchangeRates));
      emit(SettingSuccess());
    } catch (e) {
      emit(SettingError(e.toString()));
    }
  }

  Future<void> updateExchangeRates({
    double? usdToAED,
    double? eurToAED,
  }) async {
    final currentState = this.state;
    if (currentState is! SettingLoaded) return;

    try {
      final updatedRates = await updateExchangeRatesUseCase(
        usdToAED: usdToAED,
        eurToAED: eurToAED,
      );
      emit(SettingLoaded(updatedRates));
    } catch (e) {
      emit(SettingError(e.toString()));
      if (currentState is SettingLoaded) {
        emit(currentState);
      }
    }
  }

  void reset() {
    if (kDebugMode) print('[SettingCubit] State reset');
    emit(SettingInitial());
  }
}
