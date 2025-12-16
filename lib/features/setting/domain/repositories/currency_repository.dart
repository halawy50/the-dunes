import 'package:the_dunes/features/setting/domain/entities/exchange_rates_entity.dart';

abstract class CurrencyRepository {
  Future<ExchangeRatesEntity> getExchangeRates();
  Future<ExchangeRatesEntity> updateExchangeRates({
    double? usdToAED,
    double? eurToAED,
  });
}

