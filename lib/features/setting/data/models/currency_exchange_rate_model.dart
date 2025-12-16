import 'package:the_dunes/features/setting/domain/entities/currency_exchange_rate_entity.dart';

class CurrencyExchangeRateModel extends CurrencyExchangeRateEntity {
  CurrencyExchangeRateModel({
    required super.id,
    required super.currencyTitle,
    super.image,
    required super.isDefault,
    required super.rateToAED,
    required super.rateFromAED,
  });

  factory CurrencyExchangeRateModel.fromJson(Map<String, dynamic> json) {
    return CurrencyExchangeRateModel(
      id: json['id'] as int,
      currencyTitle: json['currencyTitle'] as String,
      image: json['image'] as String?,
      isDefault: json['isDefault'] as bool,
      rateToAED: (json['rateToAED'] as num).toDouble(),
      rateFromAED: (json['rateFromAED'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'currencyTitle': currencyTitle,
      'image': image,
      'isDefault': isDefault,
      'rateToAED': rateToAED,
      'rateFromAED': rateFromAED,
    };
  }
}

