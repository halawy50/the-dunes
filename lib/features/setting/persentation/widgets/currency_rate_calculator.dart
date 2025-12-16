import 'package:the_dunes/features/setting/domain/entities/currency_exchange_rate_entity.dart';

class CurrencyRateCalculator {
  static double calculateRate(
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
}

