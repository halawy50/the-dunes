import 'package:flutter/material.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_cell_factory.dart';
import 'package:the_dunes/features/booking/data/models/driver_model.dart';
import 'package:the_dunes/features/booking/data/models/hotel_model.dart';
import 'package:the_dunes/features/booking/persentation/cubit/new_booking_cubit.dart';
import 'package:the_dunes/features/booking/persentation/models/new_booking_row.dart';
import 'package:the_dunes/core/widgets/base_table/booking/new_book_dropdowns.dart';

class NewBookTableCells {
  static Widget buildTicketNumber(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit,
  ) => BaseTableCellFactory.editable(
        value: row.ticketNumber,
        hint: 'booking.ticket_number',
        onChanged: (value) {
          row.ticketNumber = value;
          cubit.updateBookingRow(index, row);
        },
      );

  static Widget buildOrderNumber(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit,
  ) => BaseTableCellFactory.editable(
        value: row.orderNumber,
        hint: 'booking.order_number',
        onChanged: (value) {
          row.orderNumber = value;
          cubit.updateBookingRow(index, row);
        },
      );

  static Widget buildPickupTime(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit,
  ) => BaseTableCellFactory.editable(
        value: row.pickupTime,
        hint: 'booking.pickup_time_col',
        onChanged: (value) {
          row.pickupTime = value;
          cubit.updateBookingRow(index, row);
        },
      );

  static Widget buildGuestName(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit,
  ) {
    // Check if field has validation error
    final hasError = row.guestName.trim().isEmpty;
    
    return BaseTableCellFactory.editable(
      value: row.guestName,
      hint: 'booking.guest_name',
      hasError: hasError,
      onChanged: (value) {
        row.guestName = value;
        cubit.updateBookingRow(index, row);
      },
    );
  }

  static Widget buildPhoneNumber(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit,
  ) => BaseTableCellFactory.editable(
        value: row.phoneNumber,
        hint: 'booking.phone_number',
        onChanged: (value) {
          row.phoneNumber = value;
          cubit.updateBookingRow(index, row);
        },
      );

  static Widget buildLocation(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit,
  ) => NewBookDropdowns.buildLocationDropdown(context, row, index, cubit);

  static Widget buildStatus(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit,
  ) => NewBookDropdowns.buildStatusDropdown(context, row, index, cubit);

  static Widget buildAgent(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit,
  ) {
    // Check if field has validation error
    final hasError = row.agent == null;
    return NewBookDropdowns.buildAgentDropdown(
      context,
      row,
      index,
      cubit,
      hasError: hasError,
    );
  }

  static Widget buildHotel(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit,
  ) => BaseTableCellFactory.editable(
        value: row.hotel?.name ?? '',
        hint: 'booking.hotel_name',
        onChanged: (value) {
          // Create new HotelModel with the entered name (id: 0 for custom hotel)
          row.hotel = HotelModel(id: 0, name: value);
          cubit.updateBookingRow(index, row);
        },
      );

  static Widget buildRoom(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit,
  ) => BaseTableCellFactory.number(
        value: row.room,
        hint: 'booking.room',
        onChanged: (value) {
          row.room = value;
          cubit.updateBookingRow(index, row);
        },
      );

  static Widget buildNote(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit,
  ) => BaseTableCellFactory.editable(
        value: row.note,
        hint: 'booking.note',
        onChanged: (value) {
          row.note = value;
          cubit.updateBookingRow(index, row);
        },
      );

  static Widget buildDriver(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit,
  ) => BaseTableCellFactory.editable(
        value: row.driver?.name,
        hint: 'booking.driver',
        onChanged: (value) {
          if (value.isNotEmpty) {
            row.driver = DriverModel(id: 0, name: value);
          } else {
            row.driver = null;
          }
          cubit.updateBookingRow(index, row);
        },
      );

  static Widget buildCarNumber(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit,
  ) => BaseTableCellFactory.number(
        value: row.carNumber,
        hint: 'booking.car_number',
        onChanged: (value) {
          row.carNumber = value;
          cubit.updateBookingRow(index, row);
        },
      );

  static Widget buildPayment(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit,
  ) => NewBookDropdowns.buildPaymentDropdown(context, row, index, cubit);

  static Widget buildCurrency(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit,
  ) => NewBookDropdowns.buildCurrencyDropdown(context, row, index, cubit);

  static Widget buildPickupStatus(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit,
  ) => NewBookDropdowns.buildPickupStatusDropdown(context, row, index, cubit);

  static Widget buildDiscount(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit,
  ) => BaseTableCellFactory.editable(
        value: row.discount == 0.0 ? '' : row.discount.toStringAsFixed(0),
        hint: 'booking.discount',
        isNumeric: true,
        onChanged: (value) {
          row.discount = double.tryParse(value) ?? 0.0;
          row.calculateTotals();
          cubit.updateBookingRow(index, row);
        },
      );

  static Widget buildVoucher(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit,
  ) => BaseTableCellFactory.editable(
        value: row.voucher,
        hint: 'booking.voucher',
        onChanged: (value) {
          row.voucher = value;
          cubit.updateBookingRow(index, row);
        },
      );
}


