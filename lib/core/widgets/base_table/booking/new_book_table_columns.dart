import 'package:flutter/material.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/features/booking/persentation/cubit/new_booking_cubit.dart';
import 'package:the_dunes/features/booking/persentation/models/new_booking_row.dart';
import 'package:the_dunes/core/widgets/base_table/booking/new_book_table_cells.dart';

class NewBookTableColumns {
  static List<BaseTableColumn<NewBookingRow>> buildColumns(
    BuildContext context,
    NewBookingCubit cubit,
  ) {
    return [
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.num',
        width: 60,
        cellBuilder: (item, index) => Row(
          children: [
            Text('${index + 1}'),
            if (cubit.bookingRows.length > 1)
              IconButton(
                icon: const Icon(Icons.delete, size: 18),
                onPressed: () => cubit.removeBookingRow(index),
                color: Colors.red,
              ),
          ],
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.ticket_number',
        width: 120,
        cellBuilder: (item, index) => NewBookTableCells.buildTicketNumber(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.order_number',
        width: 120,
        cellBuilder: (item, index) => NewBookTableCells.buildOrderNumber(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.pickup_time_col',
        width: 150,
        cellBuilder: (item, index) => NewBookTableCells.buildPickupTime(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.guest_name',
        width: 180,
        cellBuilder: (item, index) => NewBookTableCells.buildGuestName(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.phone_number',
        width: 150,
        cellBuilder: (item, index) => NewBookTableCells.buildPhoneNumber(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.location',
        width: 120,
        cellBuilder: (item, index) => NewBookTableCells.buildLocation(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.status',
        width: 100,
        cellBuilder: (item, index) => NewBookTableCells.buildStatus(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.agent_name',
        width: 120,
        cellBuilder: (item, index) => NewBookTableCells.buildAgent(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.hotel_name',
        width: 200,
        cellBuilder: (item, index) => NewBookTableCells.buildHotel(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.room',
        width: 80,
        cellBuilder: (item, index) => NewBookTableCells.buildRoom(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.note',
        width: 200,
        cellBuilder: (item, index) => NewBookTableCells.buildNote(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.driver',
        width: 100,
        cellBuilder: (item, index) => NewBookTableCells.buildDriver(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.car_number',
        width: 100,
        cellBuilder: (item, index) => NewBookTableCells.buildCarNumber(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.payment',
        width: 100,
        cellBuilder: (item, index) => NewBookTableCells.buildPayment(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.currency',
        width: 100,
        cellBuilder: (item, index) => NewBookTableCells.buildCurrency(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.p_before_discount',
        width: 130,
        cellBuilder: (item, index) => Text(
          '${item.priceBeforeDiscount.toStringAsFixed(2)} ${item.currency}',
          style: const TextStyle(fontSize: 13),
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.discount',
        width: 100,
        cellBuilder: (item, index) => NewBookTableCells.buildDiscount(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.p_after_discount',
        width: 130,
        cellBuilder: (item, index) => Text(
          '${item.priceAfterDiscount.toStringAsFixed(2)} ${item.currency}',
          style: const TextStyle(fontSize: 13),
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.vat',
        width: 100,
        cellBuilder: (item, index) => Text(
          '${item.vat.toStringAsFixed(2)} ${item.currency}',
          style: const TextStyle(fontSize: 13),
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.net_profit',
        width: 130,
        cellBuilder: (item, index) => Text(
          '${item.netProfit.toStringAsFixed(2)} ${item.currency}',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ),
    ];
  }
}


