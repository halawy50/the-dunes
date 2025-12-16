import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/agents/domain/entities/agent_entity.dart';

class AgentDetailHeader extends StatelessWidget {
  final AgentEntity agent;

  const AgentDetailHeader({
    super.key,
    required this.agent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColor.WHITE,
      padding: const EdgeInsets.all(24.0),
      child: Text(
        '${'agents.agent_name'.tr()}: ${agent.name}',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}


