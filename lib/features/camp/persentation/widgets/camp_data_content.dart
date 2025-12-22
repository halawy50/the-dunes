import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/camp/domain/entities/camp_data_entity.dart';
import 'package:the_dunes/features/camp/domain/entities/camp_item_entity.dart';
import 'package:the_dunes/features/camp/persentation/widgets/camp_unified_table_widget.dart';

class CampDataContent extends StatelessWidget {
  const CampDataContent({
    super.key,
    required this.data,
    required this.onBookingStatusUpdate,
  });

  final CampDataEntity data;
  final void Function(int, String) onBookingStatusUpdate;

  Widget _buildNoDataWidget() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(child: Text('camp.no_data'.tr())),
    );
  }

  Widget _buildTableWrapper(Widget child) {
    return Container(
      color: AppColor.WHITE,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: child,
    );
  }

  List<CampItemEntity> _combineData() {
    final items = <CampItemEntity>[];
    items.addAll(data.bookings.map((b) => CampItemEntity(booking: b)));
    items.addAll(data.vouchers.map((v) => CampItemEntity(voucher: v)));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final combinedItems = _combineData();

    if (combinedItems.isEmpty) {
      return _buildNoDataWidget();
    }

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: _buildTableWrapper(
        CampUnifiedTableWidget(
          items: combinedItems,
          onStatusUpdate: (item, status) {
            onBookingStatusUpdate(item.id, status);
          },
          fillWidth: false,
        ),
      ),
    );
  }
}

