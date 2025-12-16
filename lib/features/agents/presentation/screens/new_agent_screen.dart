import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/agents/presentation/cubit/agent_cubit.dart';
import 'package:the_dunes/features/agents/presentation/widgets/new_agent_form.dart';

class NewAgentScreen extends StatelessWidget {
  const NewAgentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<AgentCubit>(),
      child: Scaffold(
        backgroundColor: AppColor.GRAY_F6F6F6,
        appBar: AppBar(
          backgroundColor: AppColor.WHITE,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColor.BLACK),
            onPressed: () => context.pop(),
          ),
        ),
        body: const NewAgentForm(),
      ),
    );
  }
}


