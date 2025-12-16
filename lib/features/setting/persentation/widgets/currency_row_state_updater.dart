import 'package:the_dunes/features/setting/persentation/cubit/setting_cubit.dart';
import 'package:the_dunes/features/setting/persentation/widgets/currency_row_controllers.dart';
import 'package:the_dunes/features/setting/persentation/widgets/currency_row_state_handler.dart';

class CurrencyRowStateUpdater {
  static void updateControllersFromState(
    SettingLoaded state,
    CurrencyRowControllers controllers,
    String currencyTitle,
    String? toCurrency1Title,
    String? toCurrency2Title,
  ) {
    final currency = CurrencyRowStateHandler.findCurrencyInState(
      state,
      currencyTitle,
    );
    if (currency != null) {
      controllers.updateControllers(
        currency: currency,
        toCurrency1: toCurrency1Title != null
            ? CurrencyRowStateHandler.findCurrencyInState(
                state,
                toCurrency1Title,
              )
            : null,
        toCurrency2: toCurrency2Title != null
            ? CurrencyRowStateHandler.findCurrencyInState(
                state,
                toCurrency2Title,
              )
            : null,
      );
    }
  }
}

