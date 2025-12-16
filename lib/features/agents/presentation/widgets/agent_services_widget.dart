import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_config.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_widget.dart';
import 'package:the_dunes/features/agents/domain/entities/agent_services_entity.dart';
import 'package:the_dunes/features/agents/domain/entities/service_agent_entity.dart';
import 'package:the_dunes/features/agents/presentation/cubit/agent_detail_cubit.dart';
import 'package:the_dunes/features/agents/presentation/widgets/add_service_dialog.dart';
import 'package:the_dunes/features/agents/presentation/widgets/agent_services_handlers.dart';
import 'package:the_dunes/features/agents/presentation/widgets/agent_services_table_columns.dart';

class AgentServicesWidget extends StatelessWidget {
  final AgentServicesEntity services;
  final int agentId;

  const AgentServicesWidget({
    super.key,
    required this.services,
    required this.agentId,
  });

  List<ServiceAgentEntity> _getAllServices() {
    final allServices = <ServiceAgentEntity>[];
    allServices.addAll(services.globalServices);
    for (final locationServices in services.locationServices.values) {
      allServices.addAll(locationServices);
    }
    return allServices;
  }

  @override
  Widget build(BuildContext context) {
    final allServices = _getAllServices();
    return Container(
      width: double.infinity,
      color: AppColor.WHITE,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'agents.services'.tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => AddServiceDialog(
                      agentId: agentId,
                      cubit: context.read<AgentDetailCubit>(),
                    ),
                  );
                },
                child: Text('agents.add_service'.tr()),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (allServices.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text('agents.no_services'.tr()),
              ),
            )
          else
            BaseTableWidget<ServiceAgentEntity>(
              columns: AgentServicesTableColumns.buildColumns(
                onEdit: (service) => AgentServicesHandlers.handleEdit(
                      context,
                      service,
                      agentId,
                    ),
                onDelete: (service) => AgentServicesHandlers.handleDelete(
                      context,
                      service,
                      agentId,
                    ),
              ),
              data: allServices,
              config: const BaseTableConfig(
                fillWidth: true,
                backgroundColor: AppColor.WHITE,
                headerColor: AppColor.GRAY_F6F6F6,
                rowMinHeight: 56,
                rowMaxHeight: 200,
                borderRadius: 8,
                showBorder: false,
              ),
            ),
        ],
      ),
    );
  }
}

