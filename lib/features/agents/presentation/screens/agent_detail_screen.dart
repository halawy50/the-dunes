import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/agents/presentation/cubit/agent_detail_cubit.dart';
import 'package:the_dunes/features/agents/presentation/widgets/agent_detail_content.dart';

class AgentDetailScreen extends StatelessWidget {
  final int agentId;

  const AgentDetailScreen({
    super.key,
    required this.agentId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = di<AgentDetailCubit>();
        cubit.loadAgentDetail(agentId);
        return cubit;
      },
      child: PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          if (!didPop) {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/agents');
            }
          }
        },
        child: Scaffold(
          backgroundColor: AppColor.GRAY_F6F6F6,
          appBar: AppBar(
            backgroundColor: AppColor.WHITE,
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColor.BLACK),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/agents');
                }
              },
            ),
            title: Text(
              'agents.agent_details'.tr(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColor.BLACK,
              ),
            ),
          ),
          body: const SizedBox(
            width: double.infinity,
            child: AgentDetailContent(),
          ),
        ),
      ),
    );
  }
}

