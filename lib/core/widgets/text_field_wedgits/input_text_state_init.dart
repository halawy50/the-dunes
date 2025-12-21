import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/select_type_text_field.dart';
import 'package:the_dunes/core/widgets/text_field_wedgits/input_text_split_handler.dart';

class InputTextStateInit {
  static void initialize({
    required BuildContext context,
    required dynamic widget,
    required TextEditingController textController,
    required Function() onTextChanged,
    required InputTextSplitHandler splitHandler,
  }) {
    textController.addListener(onTextChanged);
  }

  static void handleTextChanged({
    required TextEditingController textController,
    required Function(String)? onTextChanged,
    required SelectTypeTextField selectTypeTextField,
    required InputTextSplitHandler splitHandler,
  }) {
    if (kDebugMode) {
      print('[InputText] Text changed: ${textController.text.length} characters');
    }
    onTextChanged?.call(textController.text);

    if (selectTypeTextField == SelectTypeTextField.TEXT) {
      splitHandler.checkAndSplitText();
    }
  }
}

