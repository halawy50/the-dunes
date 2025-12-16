import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_config.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_widget.dart';
import 'package:the_dunes/features/agents/domain/entities/agent_entity.dart';
import 'package:the_dunes/features/agents/presentation/widgets/agent_table_columns.dart';

class AgentTableWidget extends StatelessWidget {
  const AgentTableWidget({
    super.key,
    required this.agents,
  });

  final List<AgentEntity> agents;

  @override
  Widget build(BuildContext context) {
    final columns = AgentTableColumns.buildColumns();

    return BaseTableWidget<AgentEntity>(
      key: ValueKey('agents_${agents.length}'),
      columns: columns,
      data: agents,
      showCheckbox: false,
      config: BaseTableConfig(
        backgroundColor: AppColor.WHITE,
        headerColor: AppColor.GRAY_F6F6F6,
        rowMinHeight: 56,
        rowMaxHeight: 200,
        borderRadius: 8,
        showBorder: false,
        fillWidth: true,
      ),
      onRowSelect: (agent, isSelected) {
        context.go('/agents/${agent.id}');
      },
    );
  }
}

