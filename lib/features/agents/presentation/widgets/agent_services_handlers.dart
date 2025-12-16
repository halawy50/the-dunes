import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/features/agents/domain/entities/service_agent_entity.dart';
import 'package:the_dunes/features/agents/presentation/cubit/agent_detail_cubit.dart';
import 'package:the_dunes/features/agents/presentation/widgets/edit_service_dialog.dart';

class AgentServicesHandlers {
  static void handleEdit(
    BuildContext context,
    ServiceAgentEntity service,
    int agentId,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<AgentDetailCubit>(),
        child: EditServiceDialog(
          service: service,
          agentId: agentId,
        ),
      ),
    );
  }

  static void handleDelete(
    BuildContext context,
    ServiceAgentEntity service,
    int agentId,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<AgentDetailCubit>(),
        child: AlertDialog(
          title: Text('common.delete_confirmation'.tr()),
          content: Text('agents.delete_service_confirmation'.tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('common.no'.tr()),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<AgentDetailCubit>().deleteService(
                      id: service.id,
                      agentId: agentId,
                    );
                Navigator.of(dialogContext).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('common.yes'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

