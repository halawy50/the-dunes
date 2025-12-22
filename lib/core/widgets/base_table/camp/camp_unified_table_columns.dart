import 'package:the_dunes/core/widgets/base_table/base_table_cell_factory.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/core/widgets/base_table/camp/camp_unified_actions_cell.dart';
import 'package:the_dunes/features/camp/domain/entities/camp_item_entity.dart';

class CampUnifiedTableColumns {
  static List<BaseTableColumn<CampItemEntity>> buildColumns({
    required void Function(CampItemEntity, String)? onStatusUpdate,
    required bool Function(int)? isUpdatingBookingStatus,
    required String? Function(int)? getUpdatingStatus,
    required bool Function(int)? isUpdatingVoucherStatus,
    required String? Function(int)? getUpdatingVoucherStatus,
  }) {
    return [
      BaseTableColumn<CampItemEntity>(
        headerKey: 'camp.table.id',
        width: 80,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.id.toString(),
        ),
      ),
      BaseTableColumn<CampItemEntity>(
        headerKey: 'camp.table.guest_name',
        width: 150,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.guestName,
        ),
      ),
      BaseTableColumn<CampItemEntity>(
        headerKey: 'camp.table.phone',
        width: 120,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.phoneNumber ?? '-',
        ),
      ),
      BaseTableColumn<CampItemEntity>(
        headerKey: 'camp.table.location',
        width: 150,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.location ?? '-',
        ),
      ),
      BaseTableColumn<CampItemEntity>(
        headerKey: 'camp.table.hotel',
        width: 150,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.hotel ?? '-',
        ),
      ),
      BaseTableColumn<CampItemEntity>(
        headerKey: 'camp.table.room',
        width: 80,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.room?.toString() ?? '-',
        ),
      ),
      BaseTableColumn<CampItemEntity>(
        headerKey: 'camp.table.pickup_time',
        width: 120,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.pickupTime ?? '-',
        ),
      ),
      BaseTableColumn<CampItemEntity>(
        headerKey: 'camp.table.driver',
        width: 120,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.driver ?? '-',
        ),
      ),
      BaseTableColumn<CampItemEntity>(
        headerKey: 'camp.table.car_number',
        width: 100,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.carNumber?.toString() ?? '-',
        ),
      ),
      if (onStatusUpdate != null)
        BaseTableColumn<CampItemEntity>(
          headerKey: 'camp.table.actions',
          width: 200,
          cellBuilder: (item, index) => CampUnifiedActionsCell.build(
            item: item,
            onStatusUpdate: onStatusUpdate,
            isUpdatingBookingStatus: isUpdatingBookingStatus,
            getUpdatingStatus: getUpdatingStatus,
            isUpdatingVoucherStatus: isUpdatingVoucherStatus,
            getUpdatingVoucherStatus: getUpdatingVoucherStatus,
          ),
        ),
    ];
  }
}

