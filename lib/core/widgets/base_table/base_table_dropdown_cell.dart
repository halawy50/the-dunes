import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class BaseTableDropdownCell<T> extends StatefulWidget {
  const BaseTableDropdownCell({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.displayText,
    this.hint,
    this.hasError = false,
  });

  final T? value;
  final List<T> items;
  final void Function(T?) onChanged;
  final String Function(T)? displayText;
  final String? hint;
  final bool hasError;

  @override
  State<BaseTableDropdownCell<T>> createState() => _BaseTableDropdownCellState<T>();
}

class _BaseTableDropdownCellState<T> extends State<BaseTableDropdownCell<T>> {
  T? _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  void didUpdateWidget(BaseTableDropdownCell<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Always sync with widget.value first
    if (widget.value != _currentValue) {
      setState(() {
        _currentValue = widget.value;
      });
    }
    
    // If items list changed (different length or different reference), 
    // check if current value still exists in new items
    final itemsChanged = widget.items.length != oldWidget.items.length ||
        (widget.items.isNotEmpty && oldWidget.items.isNotEmpty && 
         widget.items.first != oldWidget.items.first);
    
    if (itemsChanged) {
      // Check if current value exists in new items list
      if (_currentValue != null && !widget.items.contains(_currentValue)) {
        print('[BaseTableDropdownCell] 🗑️ Items changed (${oldWidget.items.length} -> ${widget.items.length}), clearing invalid selection');
        setState(() {
          _currentValue = null; // Clear old value that doesn't exist in new items
        });
        // Notify parent that value was cleared
        if (widget.value == null) {
          widget.onChanged(null);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure value exists in items list
    final validValue = widget.items.isNotEmpty && 
        _currentValue != null && 
        widget.items.contains(_currentValue) 
        ? _currentValue 
        : null;
    
    final isEnabled = widget.items.isNotEmpty;
    
    return MouseRegion(
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: SizedBox(
        height: 40,
        width: double.infinity,
            child: DropdownButtonFormField<T>(
              value: validValue,
              isExpanded: true,
              menuMaxHeight: 200,
              iconSize: 20,
              enableFeedback: false,
              borderRadius: BorderRadius.circular(8),
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
          icon: Container(
            alignment: Alignment.center,
            child: Icon(
              Icons.arrow_drop_down,
              color: isEnabled ? AppColor.GRAY_HULF : AppColor.GRAY_HULF.withOpacity(0.5),
              size: 20,
            ),
          ),
          alignment: AlignmentDirectional.centerStart,
          decoration: InputDecoration(
            hintText: validValue == null && widget.hint != null ? widget.hint!.tr() : null,
            hintStyle: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              fontWeight: FontWeight.normal,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.hasError ? Colors.red : AppColor.GRAY_D8D8D8,
                width: widget.hasError ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.hasError ? Colors.red : AppColor.GRAY_D8D8D8,
                width: widget.hasError ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.hasError ? Colors.red : AppColor.GRAY_D8D8D8,
                width: widget.hasError ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.hasError ? Colors.red : AppColor.YELLOW,
                width: widget.hasError ? 2 : 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            filled: false,
            fillColor: Colors.transparent,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            isDense: true,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 40,
            ),
          ),
          items: widget.items.map((item) {
            final text = widget.displayText != null ? widget.displayText!(item) : item.toString();
            return DropdownMenuItem<T>(
              value: item,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Tooltip(
                    message: text,
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
          itemHeight: null,
          onChanged: isEnabled ? (T? newValue) {
            setState(() {
              _currentValue = newValue;
            });
            widget.onChanged(newValue);
          } : null,
          hint: widget.hint != null
              ? Text(
                  widget.hint!.tr(),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    fontWeight: FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          selectedItemBuilder: (context) {
            return widget.items.map((item) {
              if (item == validValue && validValue != null) {
                final text = widget.displayText != null 
                    ? widget.displayText!(validValue) 
                    : validValue.toString();
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                );
              } else {
                return widget.hint != null && validValue == null
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.hint!.tr(),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            fontWeight: FontWeight.normal,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      )
                    : const SizedBox.shrink();
              }
            }).toList();
          },
        ),
      ),
    );
  }
}

