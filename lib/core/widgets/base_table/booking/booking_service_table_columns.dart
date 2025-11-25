import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_cell_factory.dart';
import 'package:the_dunes/features/booking/data/models/booking_service_model.dart';

class BookingServiceTableColumns {
  static List<BaseTableColumn<BookingServiceModel>> buildColumns() {
    return [
      BaseTableColumn<BookingServiceModel>(
        headerKey: 'booking.services',
        width: 400,
        cellBuilder: (service, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            child: Text(
              service.serviceName ?? '-',
              style: const TextStyle(
                fontSize: 13,
                color: AppColor.BLACK_0,
              ),
              maxLines: null,
              softWrap: true,
            ),
          );
        },
      ),
      BaseTableColumn<BookingServiceModel>(
        headerKey: 'booking.adult',
        width: 80,
        cellBuilder: (service, index) => BaseTableCellFactory.text(
          text: service.adultNumber.toString(),
        ),
      ),
      BaseTableColumn<BookingServiceModel>(
        headerKey: 'booking.child',
        width: 80,
        cellBuilder: (service, index) => BaseTableCellFactory.text(
          text: service.childNumber.toString(),
        ),
      ),
      BaseTableColumn<BookingServiceModel>(
        headerKey: 'booking.kid',
        width: 80,
        cellBuilder: (service, index) => BaseTableCellFactory.text(
          text: service.kidNumber.toString(),
        ),
      ),
      BaseTableColumn<BookingServiceModel>(
        headerKey: 'booking.adult_price',
        width: 120,
        cellBuilder: (service, index) => BaseTableCellFactory.text(
          text: '${service.adultPrice.toStringAsFixed(2)} AED',
        ),
      ),
      BaseTableColumn<BookingServiceModel>(
        headerKey: 'booking.child_price',
        width: 120,
        cellBuilder: (service, index) => BaseTableCellFactory.text(
          text: '${service.childPrice.toStringAsFixed(2)} AED',
        ),
      ),
      BaseTableColumn<BookingServiceModel>(
        headerKey: 'booking.kid_price',
        width: 120,
        cellBuilder: (service, index) => BaseTableCellFactory.text(
          text: '${service.kidPrice.toStringAsFixed(2)} AED',
        ),
      ),
      BaseTableColumn<BookingServiceModel>(
        headerKey: 'booking.total_price',
        width: 130,
        cellBuilder: (service, index) => BaseTableCellFactory.text(
          text: '${service.totalPriceService.toStringAsFixed(2)} AED',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
    ];
  }
}

