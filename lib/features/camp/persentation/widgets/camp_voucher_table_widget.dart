import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_config.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_widget.dart';
import 'package:the_dunes/core/widgets/base_table/camp/camp_service_table_columns.dart';
import 'package:the_dunes/core/widgets/base_table/camp/camp_voucher_table_columns.dart';
import 'package:the_dunes/features/camp/domain/entities/camp_service_entity.dart';
import 'package:the_dunes/features/camp/domain/entities/camp_voucher_entity.dart';

class CampVoucherTableWidget extends StatelessWidget {
  const CampVoucherTableWidget({
    super.key,
    required this.vouchers,
    this.fillWidth = false,
  });

  final List<CampVoucherEntity> vouchers;
  final bool fillWidth;

  @override
  Widget build(BuildContext context) {
    final columns = CampVoucherTableColumns.buildColumns();

    return BaseTableWidget<CampVoucherEntity>(
      key: ValueKey('camp_vouchers_${vouchers.length}'),
      columns: columns,
      data: vouchers,
      showCheckbox: false,
      getSubRows: (voucher) => voucher.services,
      subRowColumns: (voucher, rowIndex) {
        final serviceColumns = CampServiceTableColumns.buildColumns();
        return serviceColumns.map((col) => BaseTableColumn<dynamic>(
          headerKey: col.headerKey,
          width: col.width,
          cellBuilder: (item, index) {
            return col.cellBuilder(item as CampServiceEntity, index);
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
  }
}

