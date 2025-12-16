import 'package:the_dunes/features/setting/domain/entities/exchange_rates_entity.dart';
import 'package:the_dunes/features/setting/domain/repositories/currency_repository.dart';

class UpdateExchangeRatesUseCase {
  final CurrencyRepository repository;

  UpdateExchangeRatesUseCase(this.repository);

  Future<ExchangeRatesEntity> call({
    double? usdToAED,
    double? eurToAED,
  }) async {
    return await repository.updateExchangeRates(
      usdToAED: usdToAED,
      eurToAED: eurToAED,
    );
  }
}

