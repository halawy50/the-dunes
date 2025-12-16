import 'package:flutter/material.dart';
import 'package:the_dunes/features/setting/domain/entities/currency_exchange_rate_entity.dart';
import 'package:the_dunes/features/setting/persentation/widgets/currency_flag_icon.dart';

class CurrencyRowHeader extends StatelessWidget {
  final CurrencyExchangeRateEntity currency;

  const CurrencyRowHeader({
    super.key,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CurrencyFlagIcon(currencyTitle: currency.currencyTitle),
        const SizedBox(width: 8),
        Text(
          '1 ${currency.currencyTitle}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

