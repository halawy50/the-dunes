import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/utils/model/text_field_model.dart';

class SingleSelectWidget extends StatelessWidget {
  final String hint;
  final Color hintColor;
  final Color inputColor;
  final List<TextFieldModel> options;
  final TextFieldModel? selectedValue;
  final Function(TextFieldModel?) onChanged;

  const SingleSelectWidget({
    super.key,
    required this.hint,
    this.hintColor = AppColor.GRAY_HULF,
    this.inputColor = AppColor.BLACK,
    required this.options,
    this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<TextFieldModel>(
      value: selectedValue,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.WHITE),
          borderRadius: BorderRadius.circular(5),
        ),
        hintText: hint,
        hintStyle: TextStyle(color: hintColor, fontWeight: FontWeight.normal, fontSize: 14),
      ),
      dropdownColor: AppColor.WHITE,
      style: TextStyle(color: inputColor),
      items: options.map((item) => DropdownMenuItem<TextFieldModel>(
        value: item,
        child: Text(item.title, style: TextStyle(color: inputColor)),
      )).toList(),
      onChanged: (value) {
        onChanged(value);
      },
    );
  }
}
