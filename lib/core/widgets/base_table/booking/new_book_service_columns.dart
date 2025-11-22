import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_text_cell.dart';
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
        headerHint: 'booking.adult_count_hint',
        width: 80,
        cellBuilder: (service, serviceIndex) {
          return EditableCell(
            value: service.adult == 0 ? '' : service.adult.toString(),
            hint: 'booking.adult_count_hint',
            isNumeric: true,
            onChanged: (value) {
              final oldAdult = service.adult;
              service.adult = int.tryParse(value) ?? 0;
              print('[Adult] 🔄 Changed from $oldAdult to ${service.adult}');
              service.calculateTotal();
              row.calculateTotals();
              cubit.updateBookingRow(rowIndex, row);
              print('[Adult] ✅ Updated booking row $rowIndex');
            },
          );
        },
      ),
      BaseTableColumn<NewBookingService>(
        headerKey: 'booking.child',
        headerHint: 'booking.child_count_hint',
        width: 80,
        cellBuilder: (service, serviceIndex) {
          return EditableCell(
            value: service.child == 0 ? '' : service.child.toString(),
            hint: 'booking.child_count_hint',
            isNumeric: true,
            onChanged: (value) {
              final oldChild = service.child;
              service.child = int.tryParse(value) ?? 0;
              print('[Child] 🔄 Changed from $oldChild to ${service.child}');
              service.calculateTotal();
              row.calculateTotals();
              cubit.updateBookingRow(rowIndex, row);
              print('[Child] ✅ Updated booking row $rowIndex');
            },
          );
        },
      ),
      BaseTableColumn<NewBookingService>(
        headerKey: 'booking.kid',
        headerHint: 'booking.kid_count_hint',
        width: 80,
        cellBuilder: (service, serviceIndex) {
          return EditableCell(
            value: service.kid == 0 ? '' : service.kid.toString(),
            hint: 'booking.kid_count_hint',
            isNumeric: true,
            onChanged: (value) {
              final oldKid = service.kid;
              service.kid = int.tryParse(value) ?? 0;
              print('[Kid] 🔄 Changed from $oldKid to ${service.kid}');
              service.calculateTotal();
              row.calculateTotals();
              cubit.updateBookingRow(rowIndex, row);
              print('[Kid] ✅ Updated booking row $rowIndex');
            },
          );
        },
      ),
      BaseTableColumn<NewBookingService>(
        headerKey: 'booking.adult_price',
        headerHint: 'booking.price_per_person',
        width: 120,
        cellBuilder: (service, serviceIndex) {
          return _PriceWidget(
            key: ValueKey('adult_price_${rowIndex}_${serviceIndex}_${service.adult}_${service.serviceAgent?.id ?? 'null'}'),
            service: service,
            row: row,
            priceType: 'adult',
          );
        },
      ),
      BaseTableColumn<NewBookingService>(
        headerKey: 'booking.child_price',
        headerHint: 'booking.price_per_person',
        width: 120,
        cellBuilder: (service, serviceIndex) {
          return _PriceWidget(
            key: ValueKey('child_price_${rowIndex}_${serviceIndex}_${service.child}_${service.serviceAgent?.id ?? 'null'}'),
            service: service,
            row: row,
            priceType: 'child',
          );
        },
      ),
      BaseTableColumn<NewBookingService>(
        headerKey: 'booking.kid_price',
        headerHint: 'booking.price_per_person',
        width: 120,
        cellBuilder: (service, serviceIndex) {
          return _PriceWidget(
            key: ValueKey('kid_price_${rowIndex}_${serviceIndex}_${service.kid}_${service.serviceAgent?.id ?? 'null'}'),
            service: service,
            row: row,
            priceType: 'kid',
          );
        },
      ),
      BaseTableColumn<NewBookingService>(
        headerKey: 'booking.total_price',
        width: 130,
        cellBuilder: (service, serviceIndex) {
          return _TotalPriceWidget(
            key: ValueKey('total_price_${rowIndex}_${serviceIndex}_${service.adult}_${service.child}_${service.kid}_${service.serviceAgent?.id ?? 'null'}'),
            service: service,
            serviceIndex: serviceIndex,
            row: row,
            rowIndex: rowIndex,
            cubit: cubit,
          );
        },
      ),
    ];
  }
}

class _TotalPriceWidget extends StatefulWidget {
  final NewBookingService service;
  final int serviceIndex;
  final NewBookingRow row;
  final int rowIndex;
  final NewBookingCubit cubit;

  const _TotalPriceWidget({
    super.key,
    required this.service,
    required this.serviceIndex,
    required this.row,
    required this.rowIndex,
    required this.cubit,
  });

  @override
  State<_TotalPriceWidget> createState() => _TotalPriceWidgetState();
}

class _TotalPriceWidgetState extends State<_TotalPriceWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<NewBookingCubit, NewBookingState>(
      listener: (context, state) {
        if (state is NewBookingLoaded) {
          // Force rebuild when state changes
          print('[TotalPriceWidget] 🔄 NewBookingLoaded state received, rebuilding...');
          if (mounted) {
            setState(() {});
          }
        }
      },
      child: Builder(
        builder: (context) {
          // Recalculate to ensure total price is up to date
          widget.service.calculateTotal();
          print('[TotalPrice] 💰 Displaying total: ${widget.service.totalPrice} for service ${widget.service.serviceAgent?.serviceName}');
          
          // Only show delete button if there is more than one service
          final canDelete = widget.row.services.length > 1;
          
          return Row(
            children: [
              Expanded(
                child: Text(
                  '${widget.service.totalPrice.toStringAsFixed(2)} ${widget.row.currency}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: widget.service.totalPrice > 0 ? Colors.green : Colors.black,
                  ),
                ),
              ),
              if (canDelete)
                IconButton(
                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                  onPressed: () {
                    widget.row.services.removeAt(widget.serviceIndex);
                    widget.row.calculateTotals();
                    widget.cubit.updateBookingRow(widget.rowIndex, widget.row);
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

class _PriceWidget extends StatefulWidget {
  final NewBookingService service;
  final NewBookingRow row;
  final String priceType;

  const _PriceWidget({
    super.key,
    required this.service,
    required this.row,
    required this.priceType,
  });

  @override
  State<_PriceWidget> createState() => _PriceWidgetState();
}

class _PriceWidgetState extends State<_PriceWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<NewBookingCubit, NewBookingState>(
      listener: (context, state) {
        if (state is NewBookingLoaded) {
          // Force rebuild when state changes
          if (mounted) {
            setState(() {});
          }
        }
      },
      child: Builder(
        builder: (context) {
          // Calculate price based on count × unit price
          double calculatedPrice = 0.0;
          double unitPrice = 0.0;
          int count = 0;
          
          switch (widget.priceType) {
            case 'adult':
              unitPrice = widget.service.serviceAgent?.adultPrice ?? 0.0;
              count = widget.service.adult;
              calculatedPrice = unitPrice * count;
              break;
            case 'child':
              unitPrice = widget.service.serviceAgent?.childPrice ?? 0.0;
              count = widget.service.child;
              calculatedPrice = unitPrice * count;
              break;
            case 'kid':
              unitPrice = widget.service.serviceAgent?.kidPrice ?? 0.0;
              count = widget.service.kid;
              calculatedPrice = unitPrice * count;
              break;
          }
          
          return BaseTableTextCell(
            text: '${calculatedPrice.toStringAsFixed(2)} ${widget.row.currency}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: calculatedPrice > 0 ? FontWeight.w500 : FontWeight.normal,
              color: calculatedPrice > 0 ? Colors.black87 : Colors.black54,
            ),
          );
        },
      ),
    );
  }
}


