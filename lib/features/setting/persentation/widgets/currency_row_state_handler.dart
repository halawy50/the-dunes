import 'package:the_dunes/features/setting/domain/entities/currency_exchange_rate_entity.dart';
import 'package:the_dunes/features/setting/persentation/cubit/setting_cubit.dart';

class CurrencyRowStateHandler {
  static CurrencyExchangeRateEntity? findCurrencyInState(
    SettingLoaded state,
    String currencyTitle,
  ) {
    final title = currencyTitle.toUpperCase();
    switch (title) {
      case 'AED':
        return state.exchangeRates.aed;
      case 'USD':
        return state.exchangeRates.usd;
      case 'EUR':
        return state.exchangeRates.eur;
      default:
        return null;
    }
  }
}

