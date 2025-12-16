import 'package:the_dunes/core/widgets/base_table/base_table_cell_factory.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/core/widgets/base_table/camp/camp_booking_actions_cell.dart';
import 'package:the_dunes/features/camp/domain/entities/camp_booking_entity.dart';

class CampBookingTableColumns {
  static List<BaseTableColumn<CampBookingEntity>> buildColumns({
    required void Function(CampBookingEntity, String) onStatusUpdate,
    required bool Function(int) isUpdatingBookingStatus,
    required String? Function(int) getUpdatingStatus,
  }) {
    return [
      BaseTableColumn<CampBookingEntity>(
        headerKey: 'camp.table.guest_name',
        width: 150,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.guestName,
        ),
      ),
      BaseTableColumn<CampBookingEntity>(
        headerKey: 'camp.table.phone',
        width: 120,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.phoneNumber ?? '-',
        ),
      ),
      BaseTableColumn<CampBookingEntity>(
        headerKey: 'camp.table.hotel',
        width: 150,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.hotelName ?? '-',
        ),
      ),
      BaseTableColumn<CampBookingEntity>(
        headerKey: 'camp.table.room',
        width: 80,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.room?.toString() ?? '-',
        ),
      ),
      BaseTableColumn<CampBookingEntity>(
        headerKey: 'camp.table.pickup_time',
        width: 120,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.pickupTime ?? '-',
        ),
      ),
      BaseTableColumn<CampBookingEntity>(
        headerKey: 'camp.table.driver',
        width: 120,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.driver ?? '-',
        ),
      ),
      BaseTableColumn<CampBookingEntity>(
        headerKey: 'camp.table.car_number',
        width: 100,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.carNumber?.toString() ?? '-',
        ),
      ),
      BaseTableColumn<CampBookingEntity>(
        headerKey: 'camp.table.price',
        width: 100,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.finalPrice.toStringAsFixed(2),
        ),
      ),
      BaseTableColumn<CampBookingEntity>(
        headerKey: 'camp.table.actions',
        width: 200,
        cellBuilder: (item, index) => CampBookingActionsCell(
          booking: item,
          onStatusUpdate: onStatusUpdate,
          isUpdating: isUpdatingBookingStatus(item.id),
          updatingStatus: getUpdatingStatus(item.id),
        ),
      ),
    ];
  }
}

