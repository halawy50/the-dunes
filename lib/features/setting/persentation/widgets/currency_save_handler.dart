import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/features/setting/persentation/cubit/setting_cubit.dart';

class CurrencySaveHandler {
  static void handleSaveRate(
    BuildContext context,
    String fromCurrency,
    String? toCurrency1,
    String? toCurrency2,
    double? rate1,
    double? rate2,
  ) {
    if (rate1 == null && rate2 == null) return;

    double? usdToAED;
    double? eurToAED;

    if (fromCurrency == 'AED') {
      if (rate1 != null && toCurrency1 == 'EUR') {
        eurToAED = 1 / rate1;
      } else if (rate1 != null && toCurrency1 == 'USD') {
        usdToAED = 1 / rate1;
      }
      if (rate2 != null && toCurrency2 == 'EUR') {
        eurToAED = 1 / rate2;
      } else if (rate2 != null && toCurrency2 == 'USD') {
        usdToAED = 1 / rate2;
      }
    } else if (fromCurrency == 'USD') {
      if (rate2 != null && toCurrency2 == 'AED') {
        usdToAED = rate2;
      } else if (rate1 != null && toCurrency1 == 'EUR' && rate2 != null) {
        usdToAED = rate2;
        eurToAED = rate2 / rate1;
      }
    } else if (fromCurrency == 'EUR') {
      if (rate2 != null && toCurrency2 == 'AED') {
        eurToAED = rate2;
      } else if (rate1 != null && toCurrency1 == 'USD' && rate2 != null) {
        eurToAED = rate2;
        usdToAED = rate2 / rate1;
      }
    }

    if (usdToAED != null || eurToAED != null) {
      context.read<SettingCubit>().updateExchangeRates(
            usdToAED: usdToAED,
            eurToAED: eurToAED,
          );
    }
  }
}

