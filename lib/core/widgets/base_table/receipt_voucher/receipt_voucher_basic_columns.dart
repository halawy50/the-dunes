import 'package:the_dunes/core/widgets/base_table/base_table_cell_factory.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_model.dart';
import 'package:the_dunes/core/widgets/base_table/receipt_voucher/receipt_voucher_table_helpers.dart';

class ReceiptVoucherBasicColumns {
  static List<BaseTableColumn<ReceiptVoucherModel>> build({
    required int startNumber,
    required void Function(ReceiptVoucherModel, Map<String, dynamic>) onVoucherEdit,
    required bool Function(int, String) isUpdatingVoucher,
    required bool canEdit,
  }) {
    return [
      BaseTableColumn<ReceiptVoucherModel>(
        headerKey: 'receipt_voucher.num',
        width: 50,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: '${startNumber + index}',
        ),
      ),
      BaseTableColumn<ReceiptVoucherModel>(
        headerKey: 'receipt_voucher.date',
        width: 150,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.createAt,
        ),
      ),
      BaseTableColumn<ReceiptVoucherModel>(
        headerKey: 'receipt_voucher.guest_name',
        width: 150,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.guestName,
        ),
      ),
      BaseTableColumn<ReceiptVoucherModel>(
        headerKey: 'receipt_voucher.location',
        width: 100,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.location ?? '-',
        ),
      ),
      BaseTableColumn<ReceiptVoucherModel>(
        headerKey: 'receipt_voucher.phone_number',
        width: 130,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.phoneNumber ?? '-',
        ),
      ),
      BaseTableColumn<ReceiptVoucherModel>(
        headerKey: 'receipt_voucher.employee_name',
        width: 150,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.employeeAddedName ?? '-',
        ),
      ),
      BaseTableColumn<ReceiptVoucherModel>(
        headerKey: 'receipt_voucher.status',
        width: 140,
        cellBuilder: (item, index) => ReceiptVoucherTableHelpers.buildStatusDropdown(
          item,
          onVoucherEdit,
          isUpdatingVoucher(item.id, 'status'),
          canEdit: canEdit,
        ),
      ),
      BaseTableColumn<ReceiptVoucherModel>(
        headerKey: 'receipt_voucher.hotel_name',
        width: 170,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.hotel ?? '-',
        ),
      ),
      BaseTableColumn<ReceiptVoucherModel>(
        headerKey: 'receipt_voucher.room',
        width: 70,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.room?.toString() ?? '-',
        ),
      ),
      BaseTableColumn<ReceiptVoucherModel>(
        headerKey: 'receipt_voucher.note',
        width: 130,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.note ?? '-',
        ),
      ),
      BaseTableColumn<ReceiptVoucherModel>(
        headerKey: 'receipt_voucher.payment',
        width: 90,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.payment,
        ),
      ),
    ];
  }
}

