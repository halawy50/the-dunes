import 'package:the_dunes/core/network/api_client.dart';
import 'package:the_dunes/core/network/api_constants.dart';
import 'package:the_dunes/core/network/api_exception.dart';
import 'package:the_dunes/features/setting/data/models/exchange_rates_model.dart';

class CurrencyRemoteDataSource {
  final ApiClient apiClient;

  CurrencyRemoteDataSource(this.apiClient);

  Future<ExchangeRatesModel> getExchangeRates() async {
    try {
      final response = await apiClient.get(
        ApiConstants.currenciesExchangeRatesEndpoint,
      );
      return ExchangeRatesModel.fromJson(
        response['data'] as Map<String, dynamic>,
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<ExchangeRatesModel> updateExchangeRates({
    double? usdToAED,
    double? eurToAED,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (usdToAED != null) body['usdToAED'] = usdToAED;
      if (eurToAED != null) body['eurToAED'] = eurToAED;

      final response = await apiClient.put(
        ApiConstants.currenciesExchangeRatesEndpoint,
        body,
      );
      return ExchangeRatesModel.fromJson(
        response['data'] as Map<String, dynamic>,
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }
}

