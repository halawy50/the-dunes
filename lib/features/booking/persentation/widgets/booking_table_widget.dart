import 'package:flutter/material.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_widget.dart';
import 'package:the_dunes/features/booking/data/models/booking_model.dart';
import 'package:the_dunes/core/widgets/base_table/booking/booking_table_columns.dart';

class BookingTableWidget extends StatelessWidget {
  const BookingTableWidget({
    super.key,
    required this.bookings,
    required this.selectedBookings,
    required this.onBookingSelect,
    required this.onBookingEdit,
  });

  final List<BookingModel> bookings;
  final List<BookingModel> selectedBookings;
  final void Function(BookingModel, bool) onBookingSelect;
  final void Function(BookingModel, Map<String, dynamic>) onBookingEdit;

  @override
  Widget build(BuildContext context) {
    final columns = BookingTableColumns.buildColumns(onBookingEdit);

    return BaseTableWidget<BookingModel>(
      columns: columns,
      data: bookings,
      showCheckbox: true,
      selectedRows: selectedBookings,
      onRowSelect: onBookingSelect,
    );
  }
}

