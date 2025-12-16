import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_config.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_widget.dart';
import 'package:the_dunes/core/widgets/base_table/services/service_table_columns.dart';
import 'package:the_dunes/features/services/domain/entities/service_entity.dart';

class ServiceTableWidget extends StatelessWidget {
  const ServiceTableWidget({
    super.key,
    required this.services,
    this.onEdit,
    this.onDelete,
  });

  final List<ServiceEntity> services;
  final void Function(ServiceEntity)? onEdit;
  final void Function(ServiceEntity)? onDelete;

  @override
  Widget build(BuildContext context) {
    final columns = ServiceTableColumns.buildColumns(
      onEdit: onEdit,
      onDelete: onDelete,
    );

    return BaseTableWidget<ServiceEntity>(
      key: ValueKey('services_${services.length}'),
      columns: columns,
      data: services,
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
}

