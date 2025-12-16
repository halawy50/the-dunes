import 'package:the_dunes/features/setting/domain/entities/exchange_rates_entity.dart';
import 'package:the_dunes/features/setting/domain/repositories/currency_repository.dart';

class GetExchangeRatesUseCase {
  final CurrencyRepository repository;

  GetExchangeRatesUseCase(this.repository);

  Future<ExchangeRatesEntity> call() async {
    return await repository.getExchangeRates();
  }
}

