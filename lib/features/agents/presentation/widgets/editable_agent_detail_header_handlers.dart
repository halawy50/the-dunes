import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/features/agents/domain/entities/agent_entity.dart';
import 'package:the_dunes/features/agents/presentation/cubit/agent_detail_cubit.dart';

class EditableAgentDetailHeaderHandlers {
  static void handleSave({
    required BuildContext context,
    required TextEditingController nameController,
    required AgentEntity agent,
    required VoidCallback onComplete,
  }) {
    final newName = nameController.text.trim();
    if (newName.isEmpty) {
      return;
    }
    if (newName != agent.name) {
      context.read<AgentDetailCubit>().updateAgent(
            agentId: agent.id,
            name: newName,
          );
    }
    onComplete();
  }

  static void handleCancel({
    required TextEditingController nameController,
    required AgentEntity agent,
    required VoidCallback onComplete,
  }) {
    nameController.text = agent.name;
    onComplete();
  }

  static void showDeleteDialog({
    required BuildContext context,
    required AgentEntity agent,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('common.delete_confirmation'.tr()),
        content: Text('agents.delete_agent_confirmation'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('common.no'.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AgentDetailCubit>().deleteAgent(agent.id);
              context.go('/agents');
            },
            child: Text('common.yes'.tr()),
          ),
        ],
      ),
    );
  }
}

