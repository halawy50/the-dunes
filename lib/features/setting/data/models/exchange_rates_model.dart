import 'package:the_dunes/features/setting/data/models/currency_exchange_rate_model.dart';
import 'package:the_dunes/features/setting/domain/entities/exchange_rates_entity.dart';

class ExchangeRatesModel extends ExchangeRatesEntity {
  ExchangeRatesModel({
    required super.aed,
    required super.usd,
    required super.eur,
  });

  factory ExchangeRatesModel.fromJson(Map<String, dynamic> json) {
    return ExchangeRatesModel(
      aed: CurrencyExchangeRateModel.fromJson(
        json['aed'] as Map<String, dynamic>,
      ),
      usd: CurrencyExchangeRateModel.fromJson(
        json['usd'] as Map<String, dynamic>,
      ),
      eur: CurrencyExchangeRateModel.fromJson(
        json['eur'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'aed': (aed as CurrencyExchangeRateModel).toJson(),
      'usd': (usd as CurrencyExchangeRateModel).toJson(),
      'eur': (eur as CurrencyExchangeRateModel).toJson(),
    };
  }
}

