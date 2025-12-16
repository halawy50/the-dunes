import 'package:flutter/material.dart';
import 'package:the_dunes/features/setting/domain/entities/currency_exchange_rate_entity.dart';
import 'package:the_dunes/features/setting/persentation/widgets/currency_rate_calculator.dart';

class CurrencyRowControllers {
  final TextEditingController rate1Controller;
  final TextEditingController rate2Controller;

  CurrencyRowControllers({
    required this.rate1Controller,
    required this.rate2Controller,
  });

  void updateControllers({
    required CurrencyExchangeRateEntity currency,
    CurrencyExchangeRateEntity? toCurrency1,
    CurrencyExchangeRateEntity? toCurrency2,
  }) {
    if (toCurrency1 != null) {
      final rate = CurrencyRateCalculator.calculateRate(currency, toCurrency1);
      rate1Controller.text = rate.toStringAsFixed(2);
    }
    if (toCurrency2 != null) {
      final rate = CurrencyRateCalculator.calculateRate(currency, toCurrency2);
      rate2Controller.text = rate.toStringAsFixed(2);
    }
  }

  void dispose() {
    rate1Controller.dispose();
    rate2Controller.dispose();
  }
}

