import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/agents/domain/entities/agent_entity.dart';
import 'package:the_dunes/features/agents/presentation/widgets/editable_agent_detail_header_handlers.dart';
import 'package:the_dunes/features/agents/presentation/widgets/editable_agent_name_field.dart';
import 'package:the_dunes/features/agents/presentation/widgets/editable_agent_header_actions.dart';

class EditableAgentDetailHeader extends StatefulWidget {
  final AgentEntity agent;

  const EditableAgentDetailHeader({
    super.key,
    required this.agent,
  });

  @override
  State<EditableAgentDetailHeader> createState() =>
      _EditableAgentDetailHeaderState();
}

class _EditableAgentDetailHeaderState
    extends State<EditableAgentDetailHeader> {
  late TextEditingController _nameController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.agent.name);
  }

  @override
  void didUpdateWidget(EditableAgentDetailHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.agent.name != oldWidget.agent.name && !_isEditing) {
      _nameController.text = widget.agent.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSave() {
    EditableAgentDetailHeaderHandlers.handleSave(
      context: context,
      nameController: _nameController,
      agent: widget.agent,
      onComplete: () => setState(() => _isEditing = false),
    );
  }

  void _handleCancel() {
    EditableAgentDetailHeaderHandlers.handleCancel(
      nameController: _nameController,
      agent: widget.agent,
      onComplete: () => setState(() => _isEditing = false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColor.WHITE,
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Expanded(
            child: _isEditing
                ? EditableAgentNameField(controller: _nameController)
                : Text(
                    '${'agents.agent_name'.tr()}: ${widget.agent.name}',
                    style: const TextStyle(fontSize: 16),
                  ),
          ),
          const SizedBox(width: 8),
          EditableAgentHeaderActions(
            isEditing: _isEditing,
            agent: widget.agent,
            onEdit: () => setState(() => _isEditing = true),
            onSave: _handleSave,
            onCancel: _handleCancel,
          ),
        ],
      ),
    );
  }
}

