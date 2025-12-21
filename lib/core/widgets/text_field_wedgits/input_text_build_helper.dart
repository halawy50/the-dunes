import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/model/text_field_model.dart';
import 'package:the_dunes/core/widgets/text_field_wedgits/input_text_split_handler.dart';
import 'package:the_dunes/core/widgets/text_field_wedgits/input_text_widget_builder.dart';
import 'package:the_dunes/core/widgets/text_field_wedgits/input_text_header_widget.dart';

class InputTextBuildHelper {
  static Widget buildWidget({
    required dynamic widget,
    required TextEditingController textController,
    required InputTextSplitHandler splitHandler,
    required bool isHovered,
    required bool obscurePassword,
    required TextFieldModel? selectedSingleValue,
    required List<TextFieldModel> selectedMultiValues,
    required Function(bool) setHovered,
    required Function() toggleObscurePassword,
    required Function(TextFieldModel?) setSelectedSingleValue,
    required Function(List<TextFieldModel>) setSelectedMultiValues,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputTextHeaderWidget(
          headerHint: widget.headerHint,
          headerHintColor: widget.headerHintColor,
          isRequired: widget.isRequired,
        ),
        const SizedBox(height: 5),
        InputTextWidgetBuilder.buildInputWidget(
          selectTypeTextField: widget.selectTypeTextField,
          hint: widget.hint,
          hintColor: widget.hintColor,
          inputColor: widget.inputColor,
          listOfTextFieldModel: widget.listOfTextFieldModel,
          textController: textController,
          focusNode: widget.focusNode,
          onSubmitted: widget.onSubmitted,
          isProcessingSplit: splitHandler.isProcessingSplit,
          isHovered: isHovered,
          setHovered: setHovered,
          obscurePassword: obscurePassword,
          toggleObscurePassword: toggleObscurePassword,
          selectedSingleValue: selectedSingleValue,
          selectedMultiValues: selectedMultiValues,
          onSingleSelectChanged: setSelectedSingleValue,
          onMultiSelectChanged: setSelectedMultiValues,
        ),
      ],
    );
  }
}

