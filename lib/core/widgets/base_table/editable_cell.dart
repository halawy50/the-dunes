import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class EditableCell extends StatefulWidget {
  const EditableCell({
    super.key,
    required this.value,
    required this.onChanged,
    this.hint,
    this.isNumeric = false,
    this.hasError = false,
  });

  final String? value;
  final void Function(String) onChanged;
  final String? hint;
  final bool isNumeric;
  final bool hasError;

  @override
  State<EditableCell> createState() => _EditableCellState();
}

class _EditableCellState extends State<EditableCell> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value ?? '');
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(EditableCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && !_isFocused) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!mounted) return;
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    if (!_focusNode.hasFocus) {
      widget.onChanged(_controller.text);
    }
  }

  void _onTextChanged(String value) {
    // Call onChanged immediately for real-time updates
    if (widget.isNumeric) {
      // For numeric fields, update immediately even if empty (to handle deletion)
      widget.onChanged(value);
      print('[EditableCell] 🔄 Text changed to: "$value"');
    }
  }

  void _handleTap() {
    if (!_focusNode.hasFocus && mounted) {
      // Use a post-frame callback to avoid rapid focus changes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_focusNode.hasFocus) {
          _focusNode.requestFocus();
        }
      });
    }
  }

  void _handleUnfocus() {
    if (mounted && _focusNode.hasFocus) {
      // Use a post-frame callback to avoid rapid focus changes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _focusNode.hasFocus) {
          _focusNode.unfocus();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.text,
      child: SizedBox(
        height: 40,
        width: double.infinity,
        child: TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          keyboardType: widget.isNumeric ? TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
          textInputAction: TextInputAction.done,
          style: const TextStyle(
            fontSize: 13,
            color: AppColor.BLACK_0,
          ),
          decoration: InputDecoration(
            hintText: widget.hint != null ? widget.hint!.tr() : null,
            hintStyle: const TextStyle(
              fontSize: 13,
              color: AppColor.GRAY_HULF,
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
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.hasError ? Colors.red : AppColor.YELLOW,
                width: widget.hasError ? 2 : 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: AppColor.WHITE,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            isDense: true,
          ),
          onTap: _handleTap,
          onFieldSubmitted: (_) => _handleUnfocus(),
          onChanged: _onTextChanged,
          onEditingComplete: _handleUnfocus,
        ),
      ),
    );
  }
}

