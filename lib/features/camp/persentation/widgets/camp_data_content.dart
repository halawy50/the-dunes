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
    required this.horizontalScrollController,
    required this.onBookingStatusUpdate,
  });

  final CampDataEntity data;
  final ScrollController horizontalScrollController;
  final void Function(int, String) onBookingStatusUpdate;

  double _calculateTableWidth() => 1300.0;

  Widget _buildNoDataWidget() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(child: Text('camp.no_data'.tr())),
    );
  }

  Widget _buildTableWrapper(Widget child, double? height, bool shouldFillWidth) {
    final container = Container(
      color: AppColor.WHITE,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: child,
    );

    if (shouldFillWidth) {
      return height != null ? SizedBox(height: height, child: container) : container;
    }

    final scrollView = SingleChildScrollView(
      controller: horizontalScrollController,
      physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: container,
    );
    return height != null ? SizedBox(height: height, child: scrollView) : scrollView;
  }

  List<CampItemEntity> _combineData() {
    final items = <CampItemEntity>[];
    items.addAll(data.bookings.map((b) => CampItemEntity(booking: b)));
    items.addAll(data.vouchers.map((v) => CampItemEntity(voucher: v)));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight.isFinite && constraints.maxHeight > 0
            ? constraints.maxHeight
            : null;
        final availableWidth = constraints.maxWidth - 48;
        final shouldFillWidth = availableWidth >= _calculateTableWidth();
        final combinedItems = _combineData();
        
        if (combinedItems.isEmpty) {
          return height != null
              ? SizedBox(
                  height: height,
                  child: _buildNoDataWidget(),
                )
              : _buildNoDataWidget();
        }
        
        return _buildTableWrapper(
          CampUnifiedTableWidget(
            items: combinedItems,
            onStatusUpdate: (item, status) {
              onBookingStatusUpdate(item.id, status);
            },
            fillWidth: shouldFillWidth,
          ),
          height,
          shouldFillWidth,
        );
      },
    );
  }
}

