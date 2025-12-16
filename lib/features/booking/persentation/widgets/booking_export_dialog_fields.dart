import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/features/booking/data/models/agent_model.dart';

class BookingExportDialogFields extends StatelessWidget {
  final int? agentId;
  final String? status;
  final List<AgentModel> agents;
  final bool loadingAgents;
  final void Function(int?) onAgentIdChanged;
  final void Function(String?) onStatusChanged;

  const BookingExportDialogFields({
    super.key,
    required this.agentId,
    required this.status,
    required this.agents,
    required this.loadingAgents,
    required this.onAgentIdChanged,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<int>(
          value: agentId,
          decoration: InputDecoration(
            labelText: 'booking.agent_name'.tr(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: loadingAgents
              ? [
                  DropdownMenuItem<int>(
                    value: null,
                    child: Text('booking.loading'.tr()),
                  ),
                ]
              : [
                  ...agents.map(
                    (agent) => DropdownMenuItem<int>(
                      value: agent.id,
                      child: Text(agent.name),
                    ),
                  ),
                ],
          onChanged: loadingAgents ? null : onAgentIdChanged,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: status,
          decoration: InputDecoration(
            labelText: 'booking.status'.tr(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: [
            DropdownMenuItem<String>(
              value: null,
              child: Text('common.all'.tr()),
            ),
            ...['PENDING', 'ACCEPTED', 'COMPLETED', 'CANCELLED']
                .map(
                  (s) => DropdownMenuItem<String>(
                    value: s,
                    child: Text(s),
                  ),
                )
                .toList(),
          ],
          onChanged: onStatusChanged,
        ),
      ],
    );
  }
}

