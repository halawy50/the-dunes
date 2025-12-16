import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/features/setting/domain/entities/exchange_rates_entity.dart';

class UpdateExchangeRatesForm extends StatefulWidget {
  final ExchangeRatesEntity currentRates;
  final GlobalKey<FormState> formKey;
  final TextEditingController usdController;
  final TextEditingController eurController;

  const UpdateExchangeRatesForm({
    super.key,
    required this.currentRates,
    required this.formKey,
    required this.usdController,
    required this.eurController,
  });

  @override
  State<UpdateExchangeRatesForm> createState() =>
      _UpdateExchangeRatesFormState();
}

class _UpdateExchangeRatesFormState extends State<UpdateExchangeRatesForm> {
  @override
  void initState() {
    super.initState();
    widget.usdController.text =
        widget.currentRates.usd.rateToAED.toStringAsFixed(2);
    widget.eurController.text =
        widget.currentRates.eur.rateToAED.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: widget.usdController,
              decoration: InputDecoration(
                labelText: 'setting.usd_to_aed'.tr(),
                hintText: 'setting.enter_usd_rate'.tr(),
                border: const OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return null;
                }
                final rate = double.tryParse(value);
                if (rate == null || rate <= 0) {
                  return 'setting.invalid_rate'.tr();
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: widget.eurController,
              decoration: InputDecoration(
                labelText: 'setting.eur_to_aed'.tr(),
                hintText: 'setting.enter_eur_rate'.tr(),
                border: const OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return null;
                }
                final rate = double.tryParse(value);
                if (rate == null || rate <= 0) {
                  return 'setting.invalid_rate'.tr();
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}

