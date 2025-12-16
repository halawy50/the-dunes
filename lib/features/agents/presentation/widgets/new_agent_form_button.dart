import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/features/agents/presentation/cubit/agent_cubit.dart';
import 'package:the_dunes/features/agents/presentation/cubit/agent_state.dart';

class NewAgentFormButton extends StatelessWidget {
  final VoidCallback onPressed;

  const NewAgentFormButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgentCubit, AgentState>(
      builder: (context, state) {
        final isLoading = state is AgentLoading;
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text('common.save'.tr()),
        );
      },
    );
  }
}

