import 'package:flutter/material.dart';

class BaseTableColumn<T> {
  final String headerKey;
  final double? width;
  final Widget Function(T item, int index) cellBuilder;
  final bool isEditable;
  final void Function(T item, dynamic newValue)? onCellEdit;
  final EdgeInsets? headerPadding;
  final String? headerHint;

  const BaseTableColumn({
    required this.headerKey,
    this.width,
    required this.cellBuilder,
    this.isEditable = false,
    this.onCellEdit,
    this.headerPadding,
    this.headerHint,
  });
}


