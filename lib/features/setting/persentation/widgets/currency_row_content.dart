import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/setting/domain/entities/currency_exchange_rate_entity.dart';
import 'package:the_dunes/features/setting/persentation/widgets/currency_rate_field.dart';
import 'package:the_dunes/features/setting/persentation/widgets/currency_row_actions.dart';
import 'package:the_dunes/features/setting/persentation/widgets/currency_row_header.dart';

class CurrencyRowContent extends StatelessWidget {
  final CurrencyExchangeRateEntity currency;
  final CurrencyExchangeRateEntity? toCurrency1;
  final CurrencyExchangeRateEntity? toCurrency2;
  final TextEditingController rate1Controller;
  final TextEditingController rate2Controller;
  final bool isEditing;
  final bool isSaving;
  final VoidCallback onEdit;
  final VoidCallback onSave;
  final VoidCallback onFieldTap;

  const CurrencyRowContent({
    super.key,
    required this.currency,
    this.toCurrency1,
    this.toCurrency2,
    required this.rate1Controller,
    required this.rate2Controller,
    required this.isEditing,
    required this.isSaving,
    required this.onEdit,
    required this.onSave,
    required this.onFieldTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColor.WHITE,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.GRAY_DARK),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              CurrencyRowHeader(currency: currency),
              if (toCurrency1 != null)
                CurrencyRateField(
                  currency: toCurrency1!,
                  controller: rate1Controller,
                  isEditing: isEditing && !isSaving,
                  onTap: onFieldTap,
                ),
              if (toCurrency2 != null)
                CurrencyRateField(
                  currency: toCurrency2!,
                  controller: rate2Controller,
                  isEditing: isEditing && !isSaving,
                  onTap: onFieldTap,
                ),
              const Spacer(),
              if (isSaving)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else
                CurrencyRowActions(
                  isEditing: isEditing,
                  onEdit: onEdit,
                  onSave: onSave,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

