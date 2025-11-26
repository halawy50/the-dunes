import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_widget.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/features/booking/data/models/booking_model.dart';
import 'package:the_dunes/features/booking/data/models/booking_service_model.dart';
import 'package:the_dunes/core/widgets/base_table/booking/booking_table_columns.dart';
import 'package:the_dunes/core/widgets/base_table/booking/booking_service_table_columns.dart';
import 'package:the_dunes/features/booking/persentation/cubit/booking_cubit.dart';

class BookingTableWidget extends StatelessWidget {
  const BookingTableWidget({
    super.key,
    required this.bookings,
    required this.selectedBookings,
    required this.onBookingSelect,
    required this.onBookingEdit,
    required this.onBookingDelete,
  });

  final List<BookingModel> bookings;
  final List<BookingModel> selectedBookings;
  final void Function(BookingModel, bool) onBookingSelect;
  final void Function(BookingModel, Map<String, dynamic>) onBookingEdit;
  final void Function(BookingModel) onBookingDelete;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        final cubit = context.read<BookingCubit>();
        final currentPage = cubit.currentPage;
        final pageSize = cubit.pageSize;
        final startNumber = (currentPage - 1) * pageSize + 1;
        final columns = BookingTableColumns.buildColumns(
          onBookingEdit,
          (id, fieldName) => cubit.isUpdatingBooking(id, fieldName),
          onBookingDelete,
          (id) => cubit.isDeletingBooking(id),
          startNumber: startNumber,
        );

        return BaseTableWidget<BookingModel>(
      key: ValueKey('bookings_${bookings.length}_${bookings.isNotEmpty ? bookings.first.id : 0}'),
      columns: columns,
      data: bookings,
      showCheckbox: true,
      selectedRows: selectedBookings,
      onRowSelect: onBookingSelect,
      getSubRows: (booking) => booking.services,
      subRowColumns: (booking, rowIndex) {
        final serviceColumns = BookingServiceTableColumns.buildColumns();
        return serviceColumns.map((col) => BaseTableColumn<dynamic>(
          headerKey: col.headerKey,
          width: col.width,
          cellBuilder: (item, index) {
            return col.cellBuilder(item as BookingServiceModel, index);
          },
          headerPadding: col.headerPadding,
          headerHint: col.headerHint,
        )).toList();
      },
        );
      },
    );
  }
}

