import 'package:the_dunes/core/widgets/base_table/base_table_cell_factory.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/features/camp/domain/entities/camp_voucher_entity.dart';

class CampVoucherTableColumns {
  static List<BaseTableColumn<CampVoucherEntity>> buildColumns() {
    return [
      BaseTableColumn<CampVoucherEntity>(
        headerKey: 'camp.table.guest_name',
        width: 150,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.guestName,
        ),
      ),
      BaseTableColumn<CampVoucherEntity>(
        headerKey: 'camp.table.phone',
        width: 120,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.phoneNumber ?? '-',
        ),
      ),
      BaseTableColumn<CampVoucherEntity>(
        headerKey: 'camp.table.location',
        width: 150,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.location ?? '-',
        ),
      ),
      BaseTableColumn<CampVoucherEntity>(
        headerKey: 'camp.table.hotel',
        width: 150,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.hotel ?? '-',
        ),
      ),
      BaseTableColumn<CampVoucherEntity>(
        headerKey: 'camp.table.room',
        width: 80,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.room?.toString() ?? '-',
        ),
      ),
      BaseTableColumn<CampVoucherEntity>(
        headerKey: 'camp.table.driver',
        width: 120,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.driver ?? '-',
        ),
      ),
      BaseTableColumn<CampVoucherEntity>(
        headerKey: 'camp.table.car_number',
        width: 100,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.carNumber?.toString() ?? '-',
        ),
      ),
      BaseTableColumn<CampVoucherEntity>(
        headerKey: 'camp.table.price',
        width: 100,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.finalPriceAfterDeductingCommissionEmployee.toStringAsFixed(2),
        ),
      ),
    ];
  }
}

