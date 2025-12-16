import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_cell_factory.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/features/agents/domain/entities/service_agent_entity.dart';

class AgentServicesTableColumns {
  static List<BaseTableColumn<ServiceAgentEntity>> buildColumns({
    required void Function(ServiceAgentEntity) onEdit,
    required void Function(ServiceAgentEntity) onDelete,
  }) {
    return [
      BaseTableColumn<ServiceAgentEntity>(
        headerKey: 'agents.service_name',
        width: 200,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.serviceName ?? '-',
        ),
      ),
      BaseTableColumn<ServiceAgentEntity>(
        headerKey: 'agents.location',
        width: 150,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.isGlobal
              ? 'agents.global_service'.tr()
              : (item.locationName ?? '-'),
        ),
      ),
      BaseTableColumn<ServiceAgentEntity>(
        headerKey: 'agents.adult_price',
        width: 120,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: '${item.adultPrice.toStringAsFixed(2)} AED',
        ),
      ),
      BaseTableColumn<ServiceAgentEntity>(
        headerKey: 'agents.child_price',
        width: 120,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.childPrice != null
              ? '${item.childPrice!.toStringAsFixed(2)} AED'
              : '-',
        ),
      ),
      BaseTableColumn<ServiceAgentEntity>(
        headerKey: 'agents.kid_price',
        width: 120,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.kidPrice != null
              ? '${item.kidPrice!.toStringAsFixed(2)} AED'
              : '-',
        ),
      ),
      BaseTableColumn<ServiceAgentEntity>(
        headerKey: 'common.actions',
        width: 120,
        cellBuilder: (item, index) => _buildActionsCell(
          item,
          onEdit,
          onDelete,
        ),
      ),
    ];
  }

  static Widget _buildActionsCell(
    ServiceAgentEntity service,
    void Function(ServiceAgentEntity) onEdit,
    void Function(ServiceAgentEntity) onDelete,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: AppColor.YELLOW, size: 20),
          onPressed: () => onEdit(service),
          tooltip: 'common.edit'.tr(),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red, size: 20),
          onPressed: () => onDelete(service),
          tooltip: 'common.delete'.tr(),
        ),
      ],
    );
  }
}

