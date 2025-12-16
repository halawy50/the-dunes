import 'package:flutter/material.dart';
import 'package:the_dunes/features/setting/domain/entities/currency_exchange_rate_entity.dart';
import 'package:the_dunes/features/setting/persentation/cubit/setting_cubit.dart';
import 'package:the_dunes/features/setting/persentation/widgets/currency_row_content.dart';
import 'package:the_dunes/features/setting/persentation/widgets/currency_row_controllers.dart';
import 'package:the_dunes/features/setting/persentation/widgets/currency_row_listener.dart';
import 'package:the_dunes/features/setting/persentation/widgets/currency_row_save_handler.dart';
import 'package:the_dunes/features/setting/persentation/widgets/currency_row_state_handler.dart';

class EditableCurrencyExchangeRateRow extends StatefulWidget {
  final CurrencyExchangeRateEntity currency;
  final CurrencyExchangeRateEntity? toCurrency1;
  final CurrencyExchangeRateEntity? toCurrency2;
  final Function(double? rate1, double? rate2)? onSave;

  const EditableCurrencyExchangeRateRow({ 
    super.key, 
    required this.currency,
    this.toCurrency1,
    this.toCurrency2,
    this.onSave,
  });

  @override
  State<EditableCurrencyExchangeRateRow> createState() =>
      _EditableCurrencyExchangeRateRowState();
}

class _EditableCurrencyExchangeRateRowState
    extends State<EditableCurrencyExchangeRateRow> {
  late CurrencyRowControllers _controllers;
  bool _isEditing = false;
  bool _isSaving = false;
  String? _originalRate1Value;
  String? _originalRate2Value;

  @override
  void initState() {
    super.initState();
    _controllers = CurrencyRowControllers(
      rate1Controller: TextEditingController(),
      rate2Controller: TextEditingController(),
    );
    _controllers.updateControllers(
      currency: widget.currency,
      toCurrency1: widget.toCurrency1,
      toCurrency2: widget.toCurrency2,
    );
    _saveOriginalValues();
  }

  void _saveOriginalValues() {
    _originalRate1Value = _controllers.rate1Controller.text;
    _originalRate2Value = _controllers.rate2Controller.text;
  }

  void _restoreOriginalValues() {
    if (_originalRate1Value != null) {
      _controllers.rate1Controller.text = _originalRate1Value!;
    }
    if (_originalRate2Value != null) {
      _controllers.rate2Controller.text = _originalRate2Value!;
    }
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  void _updateValuesFromState(SettingLoaded state) {
    final currency = CurrencyRowStateHandler.findCurrencyInState(
      state,
      widget.currency.currencyTitle,
    );
    if (currency != null) {
      _controllers.updateControllers(
        currency: currency,
        toCurrency1: widget.toCurrency1,
        toCurrency2: widget.toCurrency2,
      );
      _saveOriginalValues();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CurrencyRowListener(
      isSaving: _isSaving,
      onUpdateComplete: (state) {
        _updateValuesFromState(state);
        setState(() {
          _isSaving = false;
          _isEditing = false;
        });
      },
      onError: () {
        setState(() {
          _isSaving = false;
        });
      },
      child: CurrencyRowContent(
        currency: widget.currency,
        toCurrency1: widget.toCurrency1,
        toCurrency2: widget.toCurrency2,
        rate1Controller: _controllers.rate1Controller,
        rate2Controller: _controllers.rate2Controller,
        isEditing: _isEditing,
        isSaving: _isSaving,
        onEdit: () => setState(() => _isEditing = true),
        onSave: _handleSave,
        onFieldTap: () => setState(() => _isEditing = true),
      ),
    );
  }

  void _handleSave() {
    CurrencyRowSaveHandler.handleSave(
      controllers: _controllers,
      toCurrency1Title: widget.toCurrency1?.currencyTitle,
      toCurrency2Title: widget.toCurrency2?.currencyTitle,
      onSave: (rate1, rate2) {
        setState(() => _isSaving = true);
        widget.onSave?.call(rate1, rate2);
      },
      onInvalid: () {
        setState(() {
          _isEditing = false;
          _restoreOriginalValues();
        });
      },
    );
  }

}

