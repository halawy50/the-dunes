import 'package:flutter/material.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_cell_factory.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/pickup_service_entity.dart';

class PickupTimesServiceTableColumns {
  static List<BaseTableColumn<PickupServiceEntity>> buildColumns() {
    return [
      BaseTableColumn<PickupServiceEntity>(
        headerKey: 'booking.services',
        width: 400,
        cellBuilder: (service, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            child: Text(
              service.serviceName,
              style: const TextStyle(fontSize: 13),
              maxLines: null,
              softWrap: true,
            ),
          );
        },
      ),
      BaseTableColumn<PickupServiceEntity>(
        headerKey: 'booking.adult',
        width: 80,
        cellBuilder: (service, index) => BaseTableCellFactory.text(
          text: service.adultNumber.toString(),
        ),
      ),
      BaseTableColumn<PickupServiceEntity>(
        headerKey: 'booking.child',
        width: 80,
        cellBuilder: (service, index) => BaseTableCellFactory.text(
          text: service.childNumber.toString(),
        ),
      ),
      BaseTableColumn<PickupServiceEntity>(
        headerKey: 'booking.kid',
        width: 80,
        cellBuilder: (service, index) => BaseTableCellFactory.text(
          text: service.kidNumber.toString(),
        ),
      ),
      BaseTableColumn<PickupServiceEntity>(
        headerKey: 'booking.adult_price',
        width: 120,
        cellBuilder: (service, index) => BaseTableCellFactory.text(
          text: '${service.adultPrice.toStringAsFixed(2)} AED',
        ),
      ),
      BaseTableColumn<PickupServiceEntity>(
        headerKey: 'booking.child_price',
        width: 120,
        cellBuilder: (service, index) => BaseTableCellFactory.text(
          text: '${service.childPrice.toStringAsFixed(2)} AED',
        ),
      ),
      BaseTableColumn<PickupServiceEntity>(
        headerKey: 'booking.kid_price',
        width: 120,
        cellBuilder: (service, index) => BaseTableCellFactory.text(
          text: '${service.kidPrice.toStringAsFixed(2)} AED',
        ),
      ),
      BaseTableColumn<PickupServiceEntity>(
        headerKey: 'booking.total_price',
        width: 130,
        cellBuilder: (service, index) => BaseTableCellFactory.text(
          text: '${service.totalPrice.toStringAsFixed(2)} AED',
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

