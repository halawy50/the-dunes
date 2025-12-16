import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/features/agents/domain/entities/agent_entity.dart';
import 'package:the_dunes/features/agents/presentation/cubit/agent_cubit.dart';
import 'package:the_dunes/features/agents/presentation/cubit/agent_state.dart';
import 'package:the_dunes/features/agents/presentation/widgets/agent_table_actions_content.dart';

class AgentTableActions extends StatelessWidget {
  final AgentEntity agent;

  const AgentTableActions({
    super.key,
    required this.agent,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgentCubit, AgentState>(
      builder: (context, state) {
        final cubit = context.read<AgentCubit>();
        final isUpdating = cubit.isUpdatingAgent(agent.id);
        final isDeleting = cubit.isDeletingAgent(agent.id);

        return AgentTableActionsContent(
          agent: agent,
          isUpdating: isUpdating,
          isDeleting: isDeleting,
        );
      },
    );
  }
}

