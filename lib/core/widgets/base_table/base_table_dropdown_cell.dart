import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class BaseTableDropdownCell<T> extends StatelessWidget {
  const BaseTableDropdownCell({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.displayText,
    this.hint,
  });

  final T? value;
  final List<T> items;
  final void Function(T?) onChanged;
  final String Function(T)? displayText;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        isDense: true,
      ),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            displayText != null ? displayText!(item) : item.toString(),
            style: const TextStyle(fontSize: 12),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      hint: hint != null
          ? Text(
              hint!,
              style: const TextStyle(fontSize: 12, color: AppColor.GRAY_HULF),
            )
          : null,
    );
  }
}

