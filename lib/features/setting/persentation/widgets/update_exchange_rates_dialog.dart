import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/setting/domain/entities/exchange_rates_entity.dart';
import 'package:the_dunes/features/setting/persentation/cubit/setting_cubit.dart';
import 'package:the_dunes/features/setting/persentation/widgets/update_exchange_rates_form.dart';

class UpdateExchangeRatesDialog extends StatefulWidget {
  final ExchangeRatesEntity currentRates;

  const UpdateExchangeRatesDialog({
    super.key,
    required this.currentRates,
  });

  @override
  State<UpdateExchangeRatesDialog> createState() =>
      _UpdateExchangeRatesDialogState();
}

class _UpdateExchangeRatesDialogState
    extends State<UpdateExchangeRatesDialog> {
  final _usdController = TextEditingController();
  final _eurController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usdController.dispose();
    _eurController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final usdToAED = _usdController.text.isEmpty
          ? null
          : double.tryParse(_usdController.text);
      final eurToAED = _eurController.text.isEmpty
          ? null
          : double.tryParse(_eurController.text);

      if (usdToAED == null && eurToAED == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('setting.at_least_one_rate_required'.tr()),
          ),
        );
        return;
      }

      Navigator.pop(context);
      context.read<SettingCubit>().updateExchangeRates(
            usdToAED: usdToAED,
            eurToAED: eurToAED,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('setting.update_exchange_rates'.tr()),
      content: UpdateExchangeRatesForm(
        currentRates: widget.currentRates,
        formKey: _formKey,
        usdController: _usdController,
        eurController: _eurController,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('common.cancel'.tr()),
        ),
        ElevatedButton(
          onPressed: _handleSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.YELLOW,
          ),
          child: Text('common.save'.tr()),
        ),
      ],
    );
  }
}

