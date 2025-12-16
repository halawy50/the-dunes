import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_cell_factory.dart';
import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_service_model.dart';

class ReceiptVoucherServiceTableColumns {
  static List<BaseTableColumn<ReceiptVoucherServiceModel>> buildColumns() {
    return [
      BaseTableColumn<ReceiptVoucherServiceModel>(
        headerKey: 'receipt_voucher.services',
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
      BaseTableColumn<ReceiptVoucherServiceModel>(
        headerKey: 'receipt_voucher.adult',
        width: 80,
        cellBuilder: (service, index) => BaseTableCellFactory.text(
          text: service.adultNumber.toString(),
        ),
      ),
      BaseTableColumn<ReceiptVoucherServiceModel>(
        headerKey: 'receipt_voucher.child',
        width: 80,
        cellBuilder: (service, index) => BaseTableCellFactory.text(
          text: service.childNumber.toString(),
        ),
      ),
      BaseTableColumn<ReceiptVoucherServiceModel>(
        headerKey: 'receipt_voucher.kid',
        width: 80,
        cellBuilder: (service, index) => BaseTableCellFactory.text(
          text: service.kidNumber.toString(),
        ),
      ),
      BaseTableColumn<ReceiptVoucherServiceModel>(
        headerKey: 'receipt_voucher.adult_price',
        width: 120,
        cellBuilder: (service, index) => BaseTableCellFactory.text(
          text: '${service.adultPrice.toStringAsFixed(2)} AED',
        ),
      ),
      BaseTableColumn<ReceiptVoucherServiceModel>(
        headerKey: 'receipt_voucher.child_price',
        width: 120,
        cellBuilder: (service, index) => BaseTableCellFactory.text(
          text: '${service.childPrice.toStringAsFixed(2)} AED',
        ),
      ),
      BaseTableColumn<ReceiptVoucherServiceModel>(
        headerKey: 'receipt_voucher.kid_price',
        width: 120,
        cellBuilder: (service, index) => BaseTableCellFactory.text(
          text: '${service.kidPrice.toStringAsFixed(2)} AED',
        ),
      ),
      BaseTableColumn<ReceiptVoucherServiceModel>(
        headerKey: 'receipt_voucher.total_price',
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

