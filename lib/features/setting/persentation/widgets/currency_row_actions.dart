import 'package:flutter/material.dart';

class CurrencyRowActions extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onEdit;
  final VoidCallback onSave;

  const CurrencyRowActions({
    super.key,
    required this.isEditing,
    required this.onEdit,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    if (isEditing) {
      return IconButton(
        icon: const Icon(Icons.check, color: Colors.green, size: 20),
        onPressed: onSave,
      );
    }
    return IconButton(
      icon: const Icon(Icons.edit, size: 18),
      onPressed: onEdit,
    );
  }
}

