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
        width: 100,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.bookingDate,
        ),
      ),
      BaseTableColumn<BookingModel>(
        headerKey: 'booking.ticket_number',
        width: 120,
        isEditable: true,
        cellBuilder: (item, index) => BaseTableCellFactory.editable(
          value: item.voucher,
          hint: 'booking.ticket_number',
          onChanged: (value) => onBookingEdit(item, {'voucher': value}),
        ),
      ),
      BaseTableColumn<BookingModel>(
        headerKey: 'booking.order_number',
        width: 120,
        isEditable: true,
        cellBuilder: (item, index) => BaseTableCellFactory.editable(
          value: item.orderNumber,
          hint: 'booking.order_number',
          onChanged: (value) => onBookingEdit(item, {'orderNumber': value}),
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
        headerKey: 'booking.employee',
        width: 150,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.employeeName,
        ),
      ),
      BaseTableColumn<BookingModel>(
        headerKey: 'booking.guest_name',
        width: 180,
        isEditable: true,
        cellBuilder: (item, index) => BaseTableCellFactory.editable(
          value: item.guestName,
          hint: 'booking.guest_name',
          onChanged: (value) => onBookingEdit(item, {'guestName': value}),
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
        isEditable: true,
        cellBuilder: (item, index) => BaseTableCellFactory.editable(
          value: item.phoneNumber,
          hint: 'booking.phone_number',
          onChanged: (value) => onBookingEdit(item, {'phoneNumber': value}),
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
        headerKey: 'booking.agent_name',
        width: 120,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.agentNameStr,
        ),
      ),
      BaseTableColumn<BookingModel>(
        headerKey: 'booking.hotel_name',
        width: 200,
        isEditable: true,
        cellBuilder: (item, index) => BaseTableCellFactory.editable(
          value: item.hotelName,
          hint: 'booking.hotel_name',
          onChanged: (value) => onBookingEdit(item, {'hotelName': value}),
        ),
      ),
      BaseTableColumn<BookingModel>(
        headerKey: 'booking.room',
        width: 80,
        isEditable: true,
        cellBuilder: (item, index) => BaseTableCellFactory.number(
          value: item.room,
          hint: 'booking.room',
          onChanged: (value) => onBookingEdit(item, {'room': value}),
        ),
      ),
      BaseTableColumn<BookingModel>(
        headerKey: 'booking.note',
        width: 200,
        isEditable: true,
        cellBuilder: (item, index) => BaseTableCellFactory.editable(
          value: item.note,
          hint: 'booking.note',
          onChanged: (value) => onBookingEdit(item, {'note': value}),
        ),
      ),
      BaseTableColumn<BookingModel>(
        headerKey: 'booking.driver',
        width: 100,
        isEditable: true,
        cellBuilder: (item, index) => BaseTableCellFactory.editable(
          value: item.driver,
          hint: 'booking.driver',
          onChanged: (value) => onBookingEdit(item, {'driver': value}),
        ),
      ),
      BaseTableColumn<BookingModel>(
        headerKey: 'booking.car_number',
        width: 100,
        isEditable: true,
        cellBuilder: (item, index) => BaseTableCellFactory.number(
          value: item.carNumber,
          hint: 'booking.car_number',
          onChanged: (value) => onBookingEdit(item, {'carNumber': value}),
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

