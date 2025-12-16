import 'package:the_dunes/features/setting/domain/entities/currency_exchange_rate_entity.dart';

class ExchangeRatesEntity {
  final CurrencyExchangeRateEntity aed;
  final CurrencyExchangeRateEntity usd;
  final CurrencyExchangeRateEntity eur;

  ExchangeRatesEntity({
    required this.aed,
    required this.usd,
    required this.eur,
  });
}

