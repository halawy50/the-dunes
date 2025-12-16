import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/features/agents/presentation/cubit/agent_cubit.dart';
import 'package:the_dunes/features/agents/presentation/cubit/agent_state.dart';

class NewAgentFormListener extends StatelessWidget {
  final Widget child;

  const NewAgentFormListener({
    super.key,
    required this.child,
  });

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
          if (context.mounted) {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (context.mounted) {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/agents');
                }
              }
            });
          }
        } else if (state is AgentError) {
          AppSnackbar.showTranslated(
            context: context,
            translationKey: state.message,
            type: SnackbarType.error,
          );
        }
      },
      child: child,
    );
  }
}

