import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/setting/domain/entities/currency_exchange_rate_entity.dart';
import 'package:the_dunes/features/setting/persentation/widgets/currency_flag_icon.dart';

class CurrencyRateField extends StatelessWidget {
  final CurrencyExchangeRateEntity currency;
  final TextEditingController controller;
  final bool isEditing;
  final VoidCallback onTap;

  const CurrencyRateField({
    super.key,
    required this.currency,
    required this.controller,
    required this.isEditing,
    required this.onTap,
  });

  String _getCurrencyDisplayName(String currencyTitle) {
    switch (currencyTitle.toUpperCase()) {
      case 'EUR':
        return 'setting.currency_euro'.tr();
      case 'USD':
        return 'setting.currency_dollar'.tr();
      default:
        return currencyTitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 16),
        const Icon(Icons.swap_horiz, size: 20, color: AppColor.GRAY_HULF),
        const SizedBox(width: 8),
        CurrencyFlagIcon(currencyTitle: currency.currencyTitle),
        const SizedBox(width: 8),
        SizedBox(
          width: 70,
          child: isEditing
              ? TextFormField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d*'),
                    ),
                  ],
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(),
                  ),
                )
              : GestureDetector(
                  onTap: onTap,
                  child: Text(
                    controller.text,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
        const SizedBox(width: 4),
        Text(
          _getCurrencyDisplayName(currency.currencyTitle),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}

