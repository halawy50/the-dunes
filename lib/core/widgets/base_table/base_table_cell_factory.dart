import 'package:flutter/material.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_dropdown_cell.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_status_cell.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_text_cell.dart';
import 'package:the_dunes/core/widgets/base_table/editable_cell.dart';

class BaseTableCellFactory {
  static Widget text({
    required String? text,
    String placeholder = '-',
    TextStyle? style,
  }) {
    return BaseTableTextCell(
      text: text,
      placeholder: placeholder,
      style: style,
    );
  }

  static Widget editable({
    required String? value,
    required void Function(String) onChanged,
    String? hint,
    bool isNumeric = false,
  }) {
    return EditableCell(
      value: value,
      hint: hint,
      isNumeric: isNumeric,
      onChanged: onChanged,
    );
  }

  static Widget dropdown<T>({
    required T? value,
    required List<T> items,
    required void Function(T?) onChanged,
    String Function(T)? displayText,
    String? hint,
  }) {
    return BaseTableDropdownCell<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      displayText: displayText,
      hint: hint,
    );
  }

  static Widget status({
    required String status,
    required Color color,
    TextStyle? textStyle,
  }) {
    return BaseTableStatusCell(
      status: status,
      color: color,
      textStyle: textStyle,
    );
  }

  static Widget number({
    required int? value,
    required void Function(int?) onChanged,
    String? hint,
  }) {
    return EditableCell(
      value: value?.toString(),
      hint: hint,
      isNumeric: true,
      onChanged: (value) => onChanged(int.tryParse(value)),
    );
  }
}

