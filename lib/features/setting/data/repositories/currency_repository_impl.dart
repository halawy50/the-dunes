import 'package:the_dunes/features/setting/data/datasources/currency_remote_data_source.dart';
import 'package:the_dunes/features/setting/domain/entities/exchange_rates_entity.dart';
import 'package:the_dunes/features/setting/domain/repositories/currency_repository.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteDataSource dataSource;

  CurrencyRepositoryImpl(this.dataSource);

  @override
  Future<ExchangeRatesEntity> getExchangeRates() async {
    return await dataSource.getExchangeRates();
  }

  @override
  Future<ExchangeRatesEntity> updateExchangeRates({
    double? usdToAED,
    double? eurToAED,
  }) async {
    return await dataSource.updateExchangeRates(
      usdToAED: usdToAED,
      eurToAED: eurToAED,
    );
  }
}

