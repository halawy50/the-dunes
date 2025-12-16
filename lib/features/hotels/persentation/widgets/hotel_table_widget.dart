import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_config.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_widget.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/features/hotels/domain/entities/hotel_entity.dart';

class HotelTableWidget extends StatelessWidget {
  const HotelTableWidget({
    super.key,
    required this.hotels,
  });

  final List<HotelEntity> hotels;

  @override
  Widget build(BuildContext context) {
    final columns = _buildColumns();

    return BaseTableWidget<HotelEntity>(
      key: ValueKey('hotels_${hotels.length}'),
      columns: columns,
      data: hotels,
      showCheckbox: false,
      config: const BaseTableConfig(
        fillWidth: true,
        backgroundColor: AppColor.WHITE,
        headerColor: AppColor.GRAY_F6F6F6,
        rowMinHeight: 56,
        rowMaxHeight: 200,
        borderRadius: 8,
        showBorder: false,
      ),
    );
  }

  List<BaseTableColumn<HotelEntity>> _buildColumns() {
    return [
      BaseTableColumn<HotelEntity>(
        headerKey: 'hotels.table.id',
        width: 100,
        cellBuilder: (hotel, index) => Text('${hotel.id}'),
      ),
      BaseTableColumn<HotelEntity>(
        headerKey: 'hotels.table.name',
        width: 400,
        cellBuilder: (hotel, index) => Text(hotel.name),
      ),
    ];
  }
}

