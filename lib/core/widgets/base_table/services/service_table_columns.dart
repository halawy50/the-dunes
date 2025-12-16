import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_cell_factory.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/features/services/domain/entities/service_entity.dart';

class ServiceTableColumns {
  static List<BaseTableColumn<ServiceEntity>> buildColumns({
    void Function(ServiceEntity)? onEdit,
    void Function(ServiceEntity)? onDelete,
  }) {
    return [
      BaseTableColumn<ServiceEntity>(
        headerKey: 'services.table.id',
        width: 80,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.id.toString(),
        ),
      ),
      BaseTableColumn<ServiceEntity>(
        headerKey: 'services.table.name',
        width: 300,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.name,
        ),
      ),
      BaseTableColumn<ServiceEntity>(
        headerKey: 'services.table.description',
        width: 400,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.description ?? '-',
        ),
      ),
      if (onEdit != null || onDelete != null)
        BaseTableColumn<ServiceEntity>(
          headerKey: '',
          width: 100,
          cellBuilder: (item, index) => Builder(
            builder: (context) => _buildActionsCell(
              item,
              onEdit,
              onDelete,
              context,
            ),
          ),
        ),
    ];
  }

  static Widget _buildActionsCell(
    ServiceEntity service,
    void Function(ServiceEntity)? onEdit,
    void Function(ServiceEntity)? onDelete,
    BuildContext context,
  ) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              color: Colors.blue,
              onPressed: () => onEdit(service),
              tooltip: 'common.edit'.tr(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
            ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              color: Colors.red,
              onPressed: () => onDelete(service),
              tooltip: 'common.delete'.tr(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
            ),
        ],
      ),
    );
  }
}

