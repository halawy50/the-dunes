import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_cell_factory.dart';
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
        width: 70,
        headerPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        cellBuilder: (item, index) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                '${index + 1}',
                style: const TextStyle(fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (cubit.bookingRows.length > 1)
              IconButton(
                icon: const Icon(Icons.delete, size: 16),
                iconSize: 16,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
                onPressed: () => cubit.removeBookingRow(index),
                color: Colors.red,
              ),
          ],
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.guest_name',
        width: 220,
        headerPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        headerHint: 'booking.guest_name',
        cellBuilder: (item, index) => NewBookTableCells.buildGuestName(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.phone_number',
        width: 180,
        headerPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        cellBuilder: (item, index) => NewBookTableCells.buildPhoneNumber(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.location',
        width: 150,
        headerPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        cellBuilder: (item, index) => NewBookTableCells.buildLocation(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.agent_name',
        width: 150,
        headerPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        cellBuilder: (item, index) => NewBookTableCells.buildAgent(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.ticket_number',
        width: 150,
        headerPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        cellBuilder: (item, index) => NewBookTableCells.buildTicketNumber(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.voucher',
        width: 150,
        headerPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        cellBuilder: (item, index) => NewBookTableCells.buildVoucher(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.pickup_time_col',
        width: 180,
        headerPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        cellBuilder: (item, index) => NewBookTableCells.buildPickupTime(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.pickup_status',
        width: 140,
        headerPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        cellBuilder: (item, index) => NewBookTableCells.buildPickupStatus(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.status',
        width: 130,
        headerPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        cellBuilder: (item, index) => NewBookTableCells.buildStatus(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.hotel_name',
        width: 250,
        headerPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        cellBuilder: (item, index) => NewBookTableCells.buildHotel(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.room',
        width: 100,
        headerPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        cellBuilder: (item, index) => NewBookTableCells.buildRoom(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.driver',
        width: 130,
        headerPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        cellBuilder: (item, index) => NewBookTableCells.buildDriver(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.car_number',
        width: 130,
        headerPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        cellBuilder: (item, index) => NewBookTableCells.buildCarNumber(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.payment',
        width: 130,
        headerPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        cellBuilder: (item, index) => NewBookTableCells.buildPayment(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.currency',
        width: 130,
        headerPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        cellBuilder: (item, index) => NewBookTableCells.buildCurrency(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.p_before_discount',
        width: 160,
        headerPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        cellBuilder: (item, index) => _PriceBeforeDiscountWidget(
          price: item.priceBeforeDiscount,
          currency: item.currency,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.discount',
        width: 130,
        headerPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        cellBuilder: (item, index) => NewBookTableCells.buildDiscount(
          context,
          item,
          index,
          cubit,
        ),
      ),
      BaseTableColumn<NewBookingRow>(
        headerKey: 'booking.total_price',
        width: 160,
        headerPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        cellBuilder: (item, index) => _TotalPriceWidget(
          price: item.netProfit,
          currency: item.currency,
        ),
      ),
    ];
  }
}

class _PriceBeforeDiscountWidget extends StatelessWidget {
  final double price;
  final String currency;

  const _PriceBeforeDiscountWidget({
    required this.price,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewBookingCubit, NewBookingState>(
      builder: (context, state) {
        return BaseTableCellFactory.text(
          text: '${price.toStringAsFixed(2)} $currency',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
        );
      },
    );
  }
}

class _TotalPriceWidget extends StatelessWidget {
  final double price;
  final String currency;

  const _TotalPriceWidget({
    required this.price,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewBookingCubit, NewBookingState>(
      builder: (context, state) {
        return BaseTableCellFactory.text(
          text: '${price.toStringAsFixed(2)} $currency',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green),
        );
      },
    );
  }
}


