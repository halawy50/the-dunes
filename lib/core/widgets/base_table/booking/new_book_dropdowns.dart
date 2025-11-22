import 'package:flutter/material.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_dropdown_helpers.dart';
import 'package:the_dunes/features/booking/persentation/cubit/new_booking_cubit.dart';
import 'package:the_dunes/features/booking/persentation/models/new_booking_row.dart';
import 'package:the_dunes/core/widgets/base_table/booking/new_book_dropdowns_location_agent.dart';

class NewBookDropdowns {
  static Widget buildLocationDropdown(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit,
  ) => NewBookDropdownsLocationAgent.buildLocationDropdown(
        context,
        row,
        index,
        cubit,
      );

  static Widget buildStatusDropdown(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit,
  ) {
    final statuses = ['PENDING', 'ACCEPTED', 'COMPLETE', 'CANCELED'];
    return BaseTableDropdownHelpers.statusDropdown(
      value: row.status,
      items: statuses,
      hint: 'booking.status',
      onChanged: (value) {
        if (value != null) {
          row.status = value;
          cubit.updateBookingRow(index, row);
        }
      },
    );
  }

  static Widget buildAgentDropdown(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit, {
    bool hasError = false,
  }) => NewBookDropdownsLocationAgent.buildAgentDropdown(
        context,
        row,
        index,
        cubit,
        hasError: hasError,
      );

  static Widget buildHotelDropdown(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit,
  ) {
    final hotels = cubit.hotels;
    return BaseTableDropdownHelpers.modelDropdown<int>(
      value: row.hotel?.id,
      items: hotels.map((h) => h.id).toList(),
      hint: 'booking.hotel_name',
      onChanged: (value) {
        if (value != null) {
          row.hotel = hotels.firstWhere((h) => h.id == value);
          cubit.updateBookingRow(index, row);
        }
      },
      getDisplayText: (id) => hotels.firstWhere((h) => h.id == id).name,
    );
  }

  static Widget buildDriverDropdown(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit,
  ) {
    final drivers = cubit.drivers;
    return BaseTableDropdownHelpers.driverDropdown<int>(
      value: row.driver?.id,
      items: drivers.map((d) => d.id).toList(),
      onChanged: (value) {
        if (value != null) {
          row.driver = drivers.firstWhere((d) => d.id == value);
          cubit.updateBookingRow(index, row);
        }
      },
      getName: (id) => drivers.firstWhere((d) => d.id == id).name,
      getPhoneNumber: (id) => drivers.firstWhere((d) => d.id == id).phoneNumber,
    );
  }

  static Widget buildPaymentDropdown(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit,
  ) {
    return BaseTableDropdownHelpers.paymentDropdown(
      value: row.payment,
      hint: 'booking.payment',
      onChanged: (value) {
        if (value != null) {
          row.payment = value;
          cubit.updateBookingRow(index, row);
        }
      },
    );
  }

  static Widget buildCurrencyDropdown(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit,
  ) {
    return BaseTableDropdownHelpers.currencyDropdown(
      value: row.currency,
      hint: 'booking.currency',
      onChanged: (value) {
        if (value != null) {
          row.currency = value;
          cubit.updateBookingRow(index, row);
        }
      },
    );
  }

  static Widget buildPickupStatusDropdown(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit,
  ) {
    final pickupStatuses = ['YET', 'INWAY', 'PICKED'];
    return BaseTableDropdownHelpers.statusDropdown(
      value: row.pickupStatus ?? 'YET',
      items: pickupStatuses,
      hint: 'booking.pickup_status',
      onChanged: (value) {
        if (value != null) {
          row.pickupStatus = value;
          cubit.updateBookingRow(index, row);
        }
      },
    );
  }
}


