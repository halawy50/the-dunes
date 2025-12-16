import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/features/agents/presentation/cubit/agent_cubit.dart';
import 'package:the_dunes/features/agents/presentation/widgets/agent_screen_content.dart';

class AgentScreen extends StatelessWidget {
  const AgentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = di<AgentCubit>();
        cubit.loadAgents();
        return cubit;
      },
      child: const AgentScreenContent(),
    );
  }
}


