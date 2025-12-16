import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/agents/domain/entities/agent_entity.dart';
import 'package:the_dunes/features/agents/presentation/widgets/editable_agent_detail_header_handlers.dart';

class EditableAgentHeaderActions extends StatelessWidget {
  final bool isEditing;
  final AgentEntity agent;
  final VoidCallback onEdit;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const EditableAgentHeaderActions({
    super.key,
    required this.isEditing,
    required this.agent,
    required this.onEdit,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    if (!isEditing) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppColor.YELLOW, size: 24),
            iconSize: 24,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 40,
            ),
            onPressed: onEdit,
            tooltip: 'common.edit'.tr(),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red, size: 24),
            iconSize: 24,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 40,
            ),
            onPressed: () => EditableAgentDetailHeaderHandlers.showDeleteDialog(
              context: context,
              agent: agent,
            ),
            tooltip: 'common.delete'.tr(),
          ),
        ],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.check, color: Colors.green, size: 24),
          iconSize: 24,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
          onPressed: onSave,
          tooltip: 'common.save'.tr(),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.red, size: 24),
          iconSize: 24,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
          onPressed: onCancel,
          tooltip: 'common.cancel'.tr(),
        ),
      ],
    );
  }
}

