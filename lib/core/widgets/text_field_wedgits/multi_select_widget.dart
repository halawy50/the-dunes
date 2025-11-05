import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/utils/model/text_field_model.dart';

class MultiSelectWidget extends StatefulWidget {
  final String hint;
  final Color hintColor;
  final Color inputColor;
  final List<TextFieldModel> options;
  final List<TextFieldModel> selectedValues;
  final Function(List<TextFieldModel>) onChanged;

  const MultiSelectWidget({
    super.key,
    required this.hint,
    this.hintColor = AppColor.GRAY_HULF,
    this.inputColor = AppColor.BLACK,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
  });

  @override
  State<MultiSelectWidget> createState() => _MultiSelectWidgetState();
}

class _MultiSelectWidgetState extends State<MultiSelectWidget> {
  void _toggleSelectAll() {
    if (widget.selectedValues.length == widget.options.length) {
      widget.onChanged([]);
    } else {
      widget.onChanged(List.from(widget.options));
    }
  }

  void _toggleItem(TextFieldModel item) {
    final List<TextFieldModel> updated = List.from(widget.selectedValues);
    final existingIndex = updated.indexWhere((selected) => selected.index == item.index);
    if (existingIndex != -1) {
      updated.removeAt(existingIndex);
    } else {
      updated.add(item);
    }
    widget.onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.WHITE),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          // Select All button
          InkWell(
            onTap: _toggleSelectAll,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColor.WHITE.withOpacity(0.3))),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.selectedValues.length == widget.options.length
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: widget.inputColor,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'common.select_all'.tr(),
                    style: TextStyle(
                      color: widget.inputColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Options list
          ...widget.options.map((item) {
            final isSelected = widget.selectedValues.any((selected) => selected.index == item.index);
            return InkWell(
              onTap: () => _toggleItem(item),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColor.WHITE.withOpacity(0.1))),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                      color: widget.inputColor,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.title,
                        style: TextStyle(color: widget.inputColor, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
