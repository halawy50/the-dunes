import 'package:flutter/material.dart';
import 'package:the_dunes/features/booking/persentation/widgets/booking_export_dialog_state.dart';
import 'package:the_dunes/features/booking/persentation/widgets/booking_filter_date_range_helper.dart';

class BookingExportDialogLogic {
  static Future<void> selectCustomDateRange(
    BuildContext context,
    BookingExportDialogState state,
    void Function() onStateChanged,
  ) async {
    final start = await showDatePicker(
      context: context,
      initialDate: state.startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (start != null) {
      final end = await showDatePicker(
        context: context,
        initialDate: state.endDate ?? start,
        firstDate: start,
        lastDate: DateTime(2100),
      );
      if (end != null) {
        state.startDate = DateTime(start.year, start.month, start.day, 0, 0);
        state.endDate = DateTime(end.year, end.month, end.day, 23, 59);
        state.dateRangeOption = DateRangeOption.custom;
        onStateChanged();
      }
    }
  }

  static void handleDateRangeOption(
    BuildContext context,
    BookingExportDialogState state,
    DateRangeOption option,
    void Function() onStateChanged,
  ) {
    if (option == DateRangeOption.custom) {
      selectCustomDateRange(context, state, onStateChanged);
    } else if (option == DateRangeOption.today) {
      state.setTodayRange();
      onStateChanged();
    } else if (option == DateRangeOption.thisMonth) {
      state.setThisMonthRange();
      onStateChanged();
    } else if (option == DateRangeOption.lastMonth) {
      state.setLastMonthRange();
      onStateChanged();
    } else if (option == DateRangeOption.lastYear) {
      state.setLastYearRange();
      onStateChanged();
    }
  }
}

