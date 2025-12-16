class CurrencyExchangeRateEntity {
  final int id;
  final String currencyTitle;
  final String? image;
  final bool isDefault;
  final double rateToAED;
  final double rateFromAED;

  CurrencyExchangeRateEntity({
    required this.id,
    required this.currencyTitle,
    this.image,
    required this.isDefault,
    required this.rateToAED,
    required this.rateFromAED,
  });
}

