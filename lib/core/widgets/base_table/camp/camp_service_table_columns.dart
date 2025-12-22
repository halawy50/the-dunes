import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_cell_factory.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/features/camp/domain/entities/camp_service_entity.dart';

class CampServiceTableColumns {
  static List<BaseTableColumn<CampServiceEntity>> buildColumns() {
    return [
      BaseTableColumn<CampServiceEntity>(
        headerKey: 'camp.table.service_name',
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
      BaseTableColumn<CampServiceEntity>(
        headerKey: 'camp.table.adult',
        width: 80,
        cellBuilder: (service, index) => BaseTableCellFactory.text(
          text: service.adultNumber.toString(),
        ),
      ),
      BaseTableColumn<CampServiceEntity>(
        headerKey: 'camp.table.child',
        width: 80,
        cellBuilder: (service, index) => BaseTableCellFactory.text(
          text: service.childNumber.toString(),
        ),
      ),
      BaseTableColumn<CampServiceEntity>(
        headerKey: 'camp.table.kid',
        width: 80,
        cellBuilder: (service, index) => BaseTableCellFactory.text(
          text: service.kidNumber.toString(),
        ),
      ),
    ];
  }
}

