import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/select_type_text_field.dart';
import 'package:the_dunes/core/utils/model/text_field_model.dart';
import 'package:the_dunes/core/widgets/text_field_wedgits/single_select_widget.dart';
import 'package:the_dunes/core/widgets/text_field_wedgits/multi_select_widget.dart';
import 'package:the_dunes/core/widgets/text_field_wedgits/input_text_text_field_builder.dart';
import 'package:the_dunes/core/widgets/text_field_wedgits/input_text_text_input_widget.dart';

class InputTextWidgetBuilder {
  static Widget buildInputWidget({
    required SelectTypeTextField selectTypeTextField,
    required String hint,
    required Color hintColor,
    required Color inputColor,
    required List<TextFieldModel> listOfTextFieldModel,
    required TextEditingController textController,
    required FocusNode? focusNode,
    required VoidCallback? onSubmitted,
    required bool isProcessingSplit,
    required bool isHovered,
    required Function(bool) setHovered,
    required bool obscurePassword,
    required Function() toggleObscurePassword,
    TextFieldModel? selectedSingleValue,
    List<TextFieldModel> selectedMultiValues = const [],
    Function(TextFieldModel?)? onSingleSelectChanged,
    Function(List<TextFieldModel>)? onMultiSelectChanged,
  }) {
    switch (selectTypeTextField) {
      case SelectTypeTextField.LIST_SINGLE_SELECT:
        return SingleSelectWidget(
          hint: hint,
          hintColor: hintColor,
          inputColor: inputColor,
          options: listOfTextFieldModel,
          selectedValue: selectedSingleValue,
          onChanged: onSingleSelectChanged ?? (_) {},
        );

      case SelectTypeTextField.LIST_MULTI_SELECT:
        return MultiSelectWidget(
          hint: hint,
          hintColor: hintColor,
          inputColor: inputColor,
          options: listOfTextFieldModel,
          selectedValues: selectedMultiValues,
          onChanged: onMultiSelectChanged ?? (_) {},
        );

      case SelectTypeTextField.TEXT:
        return InputTextTextInputWidget(
          textController: textController,
          hint: hint,
          hintColor: hintColor,
          inputColor: inputColor,
          isHovered: isHovered,
          setHovered: setHovered,
          isProcessingSplit: isProcessingSplit,
        );

      default:
        return InputTextFieldBuilder.buildTextField(
          selectTypeTextField: selectTypeTextField,
          hint: hint,
          hintColor: hintColor,
          inputColor: inputColor,
          textController: textController,
          focusNode: focusNode,
          onSubmitted: onSubmitted,
          isHovered: isHovered,
          setHovered: setHovered,
          obscurePassword: obscurePassword,
          toggleObscurePassword: toggleObscurePassword,
          isProcessingSplit: isProcessingSplit,
        );
    }
  }
}
