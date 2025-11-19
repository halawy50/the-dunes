import 'package:flutter/material.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_dropdown_cell.dart';

class BaseTableDropdownHelpers {
  static Widget statusDropdown({
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return BaseTableDropdownCell<String>(
      value: value,
      items: items,
      onChanged: onChanged,
    );
  }

  static Widget modelDropdown<T>({
    required T? value,
    required List<T> items,
    required void Function(T?) onChanged,
    required String Function(T) getDisplayText,
    String? Function(T)? getValue,
  }) {
    return BaseTableDropdownCell<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      displayText: getDisplayText,
    );
  }

  static Widget paymentDropdown({
    required String? value,
    required void Function(String?) onChanged,
    List<String>? payments,
  }) {
    final paymentOptions = payments ?? ['Cash', 'Card', 'Online'];
    return BaseTableDropdownCell<String>(
      value: value,
      items: paymentOptions,
      onChanged: onChanged,
    );
  }

  static Widget currencyDropdown({
    required String? value,
    required void Function(String?) onChanged,
    List<String>? currencies,
  }) {
    final currencyOptions = currencies ?? ['AED', 'USD', 'EUR'];
    return BaseTableDropdownCell<String>(
      value: value,
      items: currencyOptions,
      onChanged: onChanged,
    );
  }

  static Widget driverDropdown<T>({
    required T? value,
    required List<T> items,
    required void Function(T?) onChanged,
    required String Function(T) getName,
    String? Function(T)? getPhoneNumber,
  }) {
    return BaseTableDropdownCell<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      displayText: (item) {
        final name = getName(item);
        final phone = getPhoneNumber?.call(item);
        return phone != null ? '$name $phone' : name;
      },
    );
  }
}

