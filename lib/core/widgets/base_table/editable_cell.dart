import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class EditableCell extends StatefulWidget {
  const EditableCell({
    super.key,
    required this.value,
    required this.onChanged,
    this.hint,
    this.isNumeric = false,
  });

  final String? value;
  final void Function(String) onChanged;
  final String? hint;
  final bool isNumeric;

  @override
  State<EditableCell> createState() => _EditableCellState();
}

class _EditableCellState extends State<EditableCell> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value ?? '');
  }

  @override
  void didUpdateWidget(EditableCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && !_isEditing) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() => _isEditing = true);
  }

  void _finishEditing() {
    setState(() => _isEditing = false);
    widget.onChanged(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing) {
      return TextField(
        controller: _controller,
        keyboardType: widget.isNumeric ? TextInputType.number : TextInputType.text,
        autofocus: true,
        style: const TextStyle(fontSize: 12),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColor.YELLOW),
            borderRadius: BorderRadius.circular(4),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          isDense: true,
        ),
        onSubmitted: (_) => _finishEditing(),
        onEditingComplete: _finishEditing,
      );
    }

    return GestureDetector(
      onTap: _startEditing,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          widget.value ?? widget.hint ?? '',
          style: TextStyle(
            fontSize: 12,
            color: widget.value == null ? AppColor.GRAY_HULF : AppColor.BLACK_0,
          ),
        ),
      ),
    );
  }
}

