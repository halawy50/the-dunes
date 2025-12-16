import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/agents/presentation/cubit/agent_cubit.dart';
import 'package:the_dunes/features/agents/presentation/widgets/new_agent_form_button.dart';
import 'package:the_dunes/features/agents/presentation/widgets/new_agent_form_listener.dart';

class NewAgentForm extends StatefulWidget {
  const NewAgentForm({super.key});

  @override
  State<NewAgentForm> createState() => _NewAgentFormState();
}

class _NewAgentFormState extends State<NewAgentForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final cubit = context.read<AgentCubit>();
      await cubit.createAgent(_nameController.text.trim());
      if (mounted) {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/agents');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return NewAgentFormListener(
      child: Container(
        color: AppColor.WHITE,
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'agents.new_agent'.tr(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: '${'agents.agent_name'.tr()} ${'common.required'.tr()}',
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'agents.name_required'.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              NewAgentFormButton(onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}

