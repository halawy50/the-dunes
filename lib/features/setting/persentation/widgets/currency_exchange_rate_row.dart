import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/setting/domain/entities/currency_exchange_rate_entity.dart';

class CurrencyExchangeRateRow extends StatelessWidget {
  final CurrencyExchangeRateEntity currency;
  final CurrencyExchangeRateEntity? toCurrency1;
  final CurrencyExchangeRateEntity? toCurrency2;

  const CurrencyExchangeRateRow({
    super.key,
    required this.currency,
    this.toCurrency1,
    this.toCurrency2,
  });

  String _getCurrencyName(String currencyTitle) {
    switch (currencyTitle.toUpperCase()) {
      case 'AED':
        return 'setting.currency_aed'.tr();
      case 'USD':
        return 'setting.currency_usd'.tr();
      case 'EUR':
        return 'setting.currency_eur'.tr();
      default:
        return currencyTitle;
    }
  }

  String _getCurrencyDisplayName(String currencyTitle) {
    switch (currencyTitle.toUpperCase()) {
      case 'EUR':
        return 'setting.currency_euro'.tr();
      case 'USD':
        return 'setting.currency_dollar'.tr();
      default:
        return _getCurrencyName(currencyTitle);
    }
  }

  double _calculateRate(
    CurrencyExchangeRateEntity from,
    CurrencyExchangeRateEntity to,
  ) {
    if (from.currencyTitle.toUpperCase() == 'AED') {
      return to.rateFromAED;
    }
    if (to.currencyTitle.toUpperCase() == 'AED') {
      return from.rateToAED;
    }
    return from.rateToAED * to.rateFromAED;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColor.WHITE,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.GRAY_DARK),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  '1 ${currency.currencyTitle}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (toCurrency1 != null) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.swap_horiz, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${_calculateRate(currency, toCurrency1!).toStringAsFixed(2)} ${_getCurrencyDisplayName(toCurrency1!.currencyTitle)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
                if (toCurrency2 != null) ...[
                  const SizedBox(width: 16),
                  const Icon(Icons.swap_horiz, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${_calculateRate(currency, toCurrency2!).toStringAsFixed(2)} ${_getCurrencyDisplayName(toCurrency2!.currencyTitle)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

