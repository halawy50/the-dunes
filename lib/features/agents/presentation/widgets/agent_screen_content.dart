import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_header.dart';
import 'package:the_dunes/features/agents/domain/entities/agent_entity.dart';
import 'package:the_dunes/features/agents/presentation/cubit/agent_cubit.dart';
import 'package:the_dunes/features/agents/presentation/cubit/agent_state.dart';
import 'package:the_dunes/features/agents/presentation/widgets/agent_table_widget.dart';

class AgentScreenContent extends StatefulWidget {
  const AgentScreenContent({super.key});

  @override
  State<AgentScreenContent> createState() => _AgentScreenContentState();
}

class _AgentScreenContentState extends State<AgentScreenContent> {
  String _searchQuery = '';

  List<AgentEntity> _filterAgents(List<AgentEntity> agents, String query) {
    if (query.isEmpty) return agents;
    final lowerQuery = query.toLowerCase();
    return agents.where((agent) {
      return agent.name.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AgentCubit, AgentState>(
      listener: (context, state) {
        if (state is AgentSuccess) {
          AppSnackbar.showTranslated(
            context: context,
            translationKey: state.message,
            type: SnackbarType.success,
          );
        } else if (state is AgentError) {
          AppSnackbar.showTranslated(
            context: context,
            translationKey: state.message,
            type: SnackbarType.error,
          );
        }
      },
      child: BlocBuilder<AgentCubit, AgentState>(
        builder: (context, state) {
          final cubit = context.read<AgentCubit>();
          List<AgentEntity> agents = <AgentEntity>[];
          if (state is AgentLoaded) {
            agents = state.agents;
          } else if (state is AgentUpdating) {
            agents = state.agents;
          } else if (state is AgentDeleting) {
            agents = state.agents;
          } else if (state is AgentSuccess) {
            agents = state.agents;
          }
          final filteredAgents = _filterAgents(agents, _searchQuery);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: AppColor.WHITE,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: BaseTableHeader(
                    onAdd: () => context.push('/agents/new'),
                    onSearch: (query) {
                      setState(() {
                        _searchQuery = query;
                      });
                    },
                    onRefresh: () async {
                      await cubit.refreshAgents();
                    },
                    hasActiveFilter: false,
                    addButtonText: 'agents.new_agent'.tr(),
                    searchHint: 'agents.search_by_name'.tr(),
                  ),
                ),
                Container(
                  color: AppColor.WHITE,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: state is AgentLoading && 
                         state is! AgentLoaded && 
                         state is! AgentUpdating && 
                         state is! AgentDeleting &&
                         state is! AgentSuccess
                      ? Container(
                          height: 400,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        )
                      : AgentTableWidget(agents: filteredAgents),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

