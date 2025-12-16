import 'package:flutter/material.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/features/agents/domain/entities/agent_entity.dart';
import 'package:the_dunes/features/agents/presentation/widgets/agent_table_actions.dart';

class AgentTableColumns {
  static List<BaseTableColumn<AgentEntity>> buildColumns() {
    return [
      BaseTableColumn<AgentEntity>(
        headerKey: 'agents.agent_name',
        width: 300,
        cellBuilder: (agent, index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              agent.name,
              style: const TextStyle(fontSize: 14),
            ),
          );
        },
      ),
      BaseTableColumn<AgentEntity>(
        headerKey: 'common.actions',
        width: 120,
        cellBuilder: (agent, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: AgentTableActions(agent: agent),
          );
        },
      ),
    ];
  }
}

