import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/setting/domain/entities/exchange_rates_entity.dart';
import 'package:the_dunes/features/setting/persentation/widgets/currency_save_handler.dart';
import 'package:the_dunes/features/setting/persentation/widgets/editable_currency_exchange_rate_row.dart';

class CurrencySection extends StatelessWidget {
  final ExchangeRatesEntity exchangeRates;

  const CurrencySection({
    super.key,
    required this.exchangeRates,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AppColor.WHITE,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'setting.currency'.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          EditableCurrencyExchangeRateRow(
            currency: exchangeRates.aed,
            toCurrency1: exchangeRates.eur,
            toCurrency2: exchangeRates.usd,
            onSave: (rate1, rate2) => CurrencySaveHandler.handleSaveRate(
              context,
              'AED',
              exchangeRates.eur.currencyTitle,
              exchangeRates.usd.currencyTitle,
              rate1,
              rate2,
            ),
          ),
          EditableCurrencyExchangeRateRow(
            currency: exchangeRates.usd,
            toCurrency1: exchangeRates.eur,
            toCurrency2: exchangeRates.aed,
            onSave: (rate1, rate2) => CurrencySaveHandler.handleSaveRate(
              context,
              'USD',
              exchangeRates.eur.currencyTitle,
              exchangeRates.aed.currencyTitle,
              rate1,
              rate2,
            ),
          ),
          EditableCurrencyExchangeRateRow(
            currency: exchangeRates.eur,
            toCurrency1: exchangeRates.usd,
            toCurrency2: exchangeRates.aed,
            onSave: (rate1, rate2) => CurrencySaveHandler.handleSaveRate(
              context,
              'EUR',
              exchangeRates.usd.currencyTitle,
              exchangeRates.aed.currencyTitle,
              rate1,
              rate2,
            ),
          ),
        ],
      ),
    );
  }
}

