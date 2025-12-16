import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/features/agents/presentation/cubit/agent_detail_cubit.dart';
import 'package:the_dunes/features/agents/presentation/cubit/agent_detail_state.dart';
import 'package:the_dunes/features/agents/presentation/widgets/editable_agent_detail_header.dart';
import 'package:the_dunes/features/agents/presentation/widgets/agent_services_widget.dart';

class AgentDetailContent extends StatelessWidget {
  const AgentDetailContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AgentDetailCubit, AgentDetailState>(
      listener: (context, state) {
        if (state is AgentDetailSuccess) {
          AppSnackbar.showTranslated(
            context: context,
            translationKey: state.message,
            type: SnackbarType.success,
          );
        } else if (state is AgentDetailError) {
          AppSnackbar.showTranslated(
            context: context,
            translationKey: state.message,
            type: SnackbarType.error,
          );
        }
      },
      child: BlocBuilder<AgentDetailCubit, AgentDetailState>(
        builder: (context, state) {
          if (state is AgentDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AgentDetailError) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          }

          if (state is AgentDetailLoaded) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  EditableAgentDetailHeader(agent: state.agent),
                  AgentServicesWidget(
                    services: state.services,
                    agentId: state.agent.id,
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

