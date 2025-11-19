import 'package:flutter/material.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/core/widgets/base_table/editable_cell.dart';
import 'package:the_dunes/features/booking/persentation/cubit/new_booking_cubit.dart';
import 'package:the_dunes/features/booking/persentation/models/new_booking_row.dart';
import 'package:the_dunes/features/booking/persentation/models/new_booking_service.dart';
import 'package:the_dunes/core/widgets/base_table/booking/new_book_service_dropdowns.dart';

class NewBookServiceColumns {
  static List<BaseTableColumn<NewBookingService>> buildColumns(
    BuildContext context,
    NewBookingRow row,
    int rowIndex,
    NewBookingCubit cubit,
  ) {
    return [
      BaseTableColumn<NewBookingService>(
        headerKey: 'booking.services',
        width: 300,
        cellBuilder: (service, serviceIndex) {
          return NewBookServiceDropdowns.buildServiceDropdown(
            context,
            service,
            serviceIndex,
            row,
            rowIndex,
            cubit,
          );
        },
      ),
      BaseTableColumn<NewBookingService>(
        headerKey: 'booking.adult',
        width: 80,
        cellBuilder: (service, serviceIndex) {
          return EditableCell(
            value: service.adult.toString(),
            hint: 'booking.adult',
            isNumeric: true,
            onChanged: (value) {
              service.adult = int.tryParse(value) ?? 0;
              service.calculateTotal();
              row.calculateTotals();
              cubit.updateBookingRow(rowIndex, row);
            },
          );
        },
      ),
      BaseTableColumn<NewBookingService>(
        headerKey: 'booking.child',
        width: 80,
        cellBuilder: (service, serviceIndex) {
          return EditableCell(
            value: service.child.toString(),
            hint: 'booking.child',
            isNumeric: true,
            onChanged: (value) {
              service.child = int.tryParse(value) ?? 0;
              service.calculateTotal();
              row.calculateTotals();
              cubit.updateBookingRow(rowIndex, row);
            },
          );
        },
      ),
      BaseTableColumn<NewBookingService>(
        headerKey: 'booking.kid',
        width: 80,
        cellBuilder: (service, serviceIndex) {
          return EditableCell(
            value: service.kid.toString(),
            hint: 'booking.kid',
            isNumeric: true,
            onChanged: (value) {
              service.kid = int.tryParse(value) ?? 0;
              service.calculateTotal();
              row.calculateTotals();
              cubit.updateBookingRow(rowIndex, row);
            },
          );
        },
      ),
      BaseTableColumn<NewBookingService>(
        headerKey: 'booking.adult_price',
        width: 120,
        cellBuilder: (service, serviceIndex) {
          return Text(
            '${service.adultPrice.toStringAsFixed(2)} ${row.currency}',
            style: const TextStyle(fontSize: 13),
          );
        },
      ),
      BaseTableColumn<NewBookingService>(
        headerKey: 'booking.child_price',
        width: 120,
        cellBuilder: (service, serviceIndex) {
          return Text(
            '${service.childPrice.toStringAsFixed(2)} ${row.currency}',
            style: const TextStyle(fontSize: 13),
          );
        },
      ),
      BaseTableColumn<NewBookingService>(
        headerKey: 'booking.kid_price',
        width: 120,
        cellBuilder: (service, serviceIndex) {
          return Text(
            '${service.kidPrice.toStringAsFixed(2)} ${row.currency}',
            style: const TextStyle(fontSize: 13),
          );
        },
      ),
      BaseTableColumn<NewBookingService>(
        headerKey: 'booking.total_price',
        width: 130,
        cellBuilder: (service, serviceIndex) {
          return Row(
            children: [
              Expanded(
                child: Text(
                  '${service.totalPrice.toStringAsFixed(2)} ${row.currency}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                onPressed: () {
                  row.services.removeAt(serviceIndex);
                  row.calculateTotals();
                  cubit.updateBookingRow(rowIndex, row);
                },
              ),
            ],
          );
        },
      ),
    ];
  }
}


