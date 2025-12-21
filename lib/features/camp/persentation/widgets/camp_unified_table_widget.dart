import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_config.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_widget.dart';
import 'package:the_dunes/core/widgets/base_table/camp/camp_service_table_columns.dart';
import 'package:the_dunes/core/widgets/base_table/camp/camp_unified_table_columns.dart';
import 'package:the_dunes/features/camp/domain/entities/camp_item_entity.dart';
import 'package:the_dunes/features/camp/domain/entities/camp_service_entity.dart';
import 'package:the_dunes/features/camp/persentation/cubit/camp_cubit.dart';

class CampUnifiedTableWidget extends StatelessWidget {
  const CampUnifiedTableWidget({
    super.key,
    required this.items,
    required this.onStatusUpdate,
    this.fillWidth = false,
  });

  final List<CampItemEntity> items;
  final void Function(CampItemEntity, String) onStatusUpdate;
  final bool fillWidth;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CampCubit, CampState>(
      builder: (context, state) {
        final cubit = context.read<CampCubit>();
        final columns = CampUnifiedTableColumns.buildColumns(
          onStatusUpdate: onStatusUpdate,
          isUpdatingBookingStatus: (bookingId) => cubit.isUpdatingBookingStatus(bookingId),
          getUpdatingStatus: (bookingId) => cubit.getUpdatingStatus(bookingId),
          isUpdatingVoucherStatus: (voucherId) => cubit.isUpdatingVoucherStatus(voucherId),
          getUpdatingVoucherStatus: (voucherId) => cubit.getUpdatingVoucherStatus(voucherId),
        );

        return BaseTableWidget<CampItemEntity>(
          columns: columns,
          data: items,
          showCheckbox: false,
          getSubRows: (item) => item.services,
          subRowColumns: (item, rowIndex) {
            final serviceColumns = CampServiceTableColumns.buildColumns();
            return serviceColumns.map((col) => BaseTableColumn<dynamic>(
              headerKey: col.headerKey,
              width: col.width,
              cellBuilder: (serviceItem, index) {
                return col.cellBuilder(serviceItem as CampServiceEntity, index);
              },
              headerPadding: col.headerPadding,
              headerHint: col.headerHint,
            )).toList();
          },
          config: BaseTableConfig(
            backgroundColor: AppColor.WHITE,
            headerColor: null,
            rowMinHeight: 56,
            rowMaxHeight: 200,
            borderRadius: 8,
            showBorder: false,
            fillWidth: fillWidth,
          ),
        );
      },
    );
  }
}

