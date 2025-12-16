import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/features/agents/domain/entities/agent_entity.dart';
import 'package:the_dunes/features/agents/presentation/cubit/agent_cubit.dart';

class AgentTableActionsHandlers {
  static void showEditDialog(BuildContext context, AgentEntity agent) {
    final nameController = TextEditingController(text: agent.name);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('common.edit'.tr()),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'agents.agent_name'.tr(),
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('common.cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              final newName = nameController.text.trim();
              if (newName.isNotEmpty && newName != agent.name) {
                context.read<AgentCubit>().updateAgent(agent.id, newName);
              }
              Navigator.of(dialogContext).pop();
            },
            child: Text('common.save'.tr()),
          ),
        ],
      ),
    );
  }

  static void showDeleteDialog(BuildContext context, AgentEntity agent) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text('common.delete_confirmation'.tr()),
        content: Text('agents.delete_agent_confirmation'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('common.no'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AgentCubit>().deleteAgent(agent.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('common.yes'.tr()),
          ),
        ],
      ),
    );
  }
}

