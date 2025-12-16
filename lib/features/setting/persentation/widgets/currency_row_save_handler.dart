import 'package:the_dunes/features/setting/persentation/widgets/currency_row_controllers.dart';

class CurrencyRowSaveHandler {
  static void handleSave({
    required CurrencyRowControllers controllers,
    String? toCurrency1Title,
    String? toCurrency2Title,
    required Function(double? rate1, double? rate2) onSave,
    required Function() onInvalid,
  }) {
    final rate1 = toCurrency1Title != null
        ? double.tryParse(controllers.rate1Controller.text)
        : null;
    final rate2 = toCurrency2Title != null
        ? double.tryParse(controllers.rate2Controller.text)
        : null;
    if (rate1 != null || rate2 != null) {
      onSave(rate1, rate2);
    } else {
      onInvalid();
    }
  }
}

