import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/agents/domain/entities/agent_entity.dart';
import 'package:the_dunes/features/agents/presentation/widgets/agent_table_actions_handlers.dart';

class AgentTableActionsContent extends StatelessWidget {
  final AgentEntity agent;
  final bool isUpdating;
  final bool isDeleting;

  const AgentTableActionsContent({
    super.key,
    required this.agent,
    required this.isUpdating,
    required this.isDeleting,
  });

  @override
  Widget build(BuildContext context) {
    if (isUpdating || isDeleting) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => AgentTableActionsHandlers.showEditDialog(
            context,
            agent,
          ),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: const Icon(Icons.edit, color: AppColor.YELLOW, size: 22),
          ),
        ),
        GestureDetector(
          onTap: () => AgentTableActionsHandlers.showDeleteDialog(
            context,
            agent,
          ),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: const Icon(Icons.delete, color: Colors.red, size: 22),
          ),
        ),
      ],
    );
  }
}

