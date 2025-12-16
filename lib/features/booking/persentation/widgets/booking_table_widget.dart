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
    required this.selectedBookings,
    required this.onBookingSelect,
    required this.onBookingEdit,
    required this.onBookingDelete,
    required this.searchQuery,
  });

  final List<BookingModel> selectedBookings;
  final void Function(BookingModel, bool) onBookingSelect;
  final void Function(BookingModel, Map<String, dynamic>) onBookingEdit;
  final void Function(BookingModel) onBookingDelete;
  final String searchQuery;

  List<BookingModel> _getFilteredBookings(List<BookingModel> bookings) {
    if (searchQuery.isEmpty) return bookings;
    return bookings.where((booking) {
      final query = searchQuery.toLowerCase();
      return booking.guestName.toLowerCase().contains(query) ||
          (booking.phoneNumber != null &&
              booking.phoneNumber!.toLowerCase().contains(query)) ||
          (booking.voucher != null &&
              booking.voucher!.toLowerCase().contains(query));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      buildWhen: (previous, current) {
        // إعادة البناء عند أي تغيير في الحالة
        if (current is BookingSuccess || 
            current is BookingUpdating || 
            current is BookingError) {
          return true;
        }
        // إعادة البناء إذا تغير timestamp في BookingSuccess
        if (previous is BookingSuccess && current is BookingSuccess) {
          return previous.timestamp != current.timestamp;
        }
        // إعادة البناء إذا تغير bookingId في BookingUpdating
        if (previous is BookingUpdating && current is BookingUpdating) {
          return previous.bookingId != current.bookingId;
        }
        return previous != current;
      },
      builder: (context, state) {
        final cubit = context.read<BookingCubit>();
        final allBookings = cubit.allBookings; // الحصول على البيانات من الـ cubit مباشرة
        final bookings = _getFilteredBookings(allBookings); // تطبيق البحث
        final currentPage = cubit.currentPage;
        final pageSize = cubit.pageSize;
        final startNumber = (currentPage - 1) * pageSize + 1;
        final timestamp = state is BookingSuccess ? state.timestamp.millisecondsSinceEpoch : 0;
        
        // إنشاء key فريد يتضمن حالة كل booking لإجبار إعادة البناء
        final statusKey = bookings.map((b) => '${b.id}_${b.statusBook}_${b.pickupStatus ?? 'YET'}').join('_');
        
        // بناء الأعمدة
        final columns = BookingTableColumns.buildColumns(
          onBookingEdit,
          (id, fieldName) => cubit.isUpdatingBooking(id, fieldName),
          onBookingDelete,
          (id) => cubit.isDeletingBooking(id),
          startNumber: startNumber,
        );
        
        return BaseTableWidget<BookingModel>(
          key: ValueKey('bookings_${bookings.length}_${statusKey}_$timestamp'),
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

