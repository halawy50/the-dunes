import 'package:flutter/material.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_cell_factory.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/features/booking/data/models/booking_model.dart';
import 'package:the_dunes/core/widgets/base_table/booking/booking_table_helpers.dart';

class BookingTableColumns {
  static List<BaseTableColumn<BookingModel>> buildColumns(
    void Function(BookingModel, Map<String, dynamic>) onBookingEdit,
  ) {
    return [
      BaseTableColumn<BookingModel>(
        headerKey: 'booking.num',
        width: 60,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: '${index + 1}',
        ),
      ),
      BaseTableColumn<BookingModel>(
        headerKey: 'booking.date',
        width: 180,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.bookingDate ?? item.time ?? '-',
        ),
      ),
      BaseTableColumn<BookingModel>(
        headerKey: 'booking.guest_name',
        width: 180,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.guestName,
        ),
      ),
      BaseTableColumn<BookingModel>(
        headerKey: 'booking.voucher',
        width: 120,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.voucher ?? '',
        ),
      ),
      BaseTableColumn<BookingModel>(
        headerKey: 'booking.status',
        width: 100,
        cellBuilder: (item, index) => BookingTableHelpers.buildStatusBookCell(
          item.statusBook,
        ),
      ),
      BaseTableColumn<BookingModel>(
        headerKey: 'booking.pickup_time_col',
        width: 150,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.pickupTime,
        ),
      ),
      BaseTableColumn<BookingModel>(
        headerKey: 'booking.pickup_status',
        width: 120,
        cellBuilder: (item, index) => BookingTableHelpers.buildStatusCell(
          item.pickupStatus,
        ),
      ),
      BaseTableColumn<BookingModel>(
        headerKey: 'booking.location',
        width: 120,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.locationName,
        ),
      ),
      BaseTableColumn<BookingModel>(
        headerKey: 'booking.phone_number',
        width: 150,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.phoneNumber,
        ),
      ),
      BaseTableColumn<BookingModel>(
        headerKey: 'booking.agent_name',
        width: 120,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.agentNameStr,
        ),
      ),
      BaseTableColumn<BookingModel>(
        headerKey: 'booking.hotel_name',
        width: 200,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.hotelName,
        ),
      ),
      BaseTableColumn<BookingModel>(
        headerKey: 'booking.room',
        width: 80,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.room?.toString() ?? '',
        ),
      ),
      BaseTableColumn<BookingModel>(
        headerKey: 'booking.driver',
        width: 100,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.driver,
        ),
      ),
      BaseTableColumn<BookingModel>(
        headerKey: 'booking.car_number',
        width: 100,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.carNumber?.toString() ?? '',
        ),
      ),
      BaseTableColumn<BookingModel>(
        headerKey: 'booking.payment',
        width: 100,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.payment,
        ),
      ),
      BaseTableColumn<BookingModel>(
        headerKey: 'booking.p_before_discount',
        width: 130,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: '${item.priceBeforePercentage.toStringAsFixed(2)} AED',
        ),
      ),
      BaseTableColumn<BookingModel>(
        headerKey: 'booking.discount',
        width: 100,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: '${((item.priceBeforePercentage - item.priceAfterPercentage) / item.priceBeforePercentage * 100).toStringAsFixed(0)}%',
        ),
      ),
      BaseTableColumn<BookingModel>(
        headerKey: 'booking.t_revenue',
        width: 130,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: '${item.finalPrice.toStringAsFixed(2)} AED',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ),
    ];
  }
}

