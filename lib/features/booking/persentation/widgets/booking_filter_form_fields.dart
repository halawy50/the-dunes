import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/features/booking/data/models/agent_model.dart';

class BookingFilterFormFields extends StatelessWidget {
  final TextEditingController guestNameController;
  final String? statusBook;
  final String? pickupStatus;
  final int? agentId;
  final List<AgentModel> agents;
  final bool loadingAgents;
  final Function(String?) onStatusBookChanged;
  final Function(String?) onPickupStatusChanged;
  final Function(int?) onAgentIdChanged;

  const BookingFilterFormFields({
    super.key,
    required this.guestNameController,
    required this.statusBook,
    required this.pickupStatus,
    required this.agentId,
    required this.agents,
    required this.loadingAgents,
    required this.onStatusBookChanged,
    required this.onPickupStatusChanged,
    required this.onAgentIdChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: guestNameController,
          decoration: InputDecoration(
            labelText: 'booking.guest_name'.tr(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: statusBook,
          decoration: InputDecoration(
            labelText: 'booking.status'.tr(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: [
            DropdownMenuItem<String>(
              value: null,
              child: Text('common.none'.tr()),
            ),
            ...['PENDING', 'ACCEPTED', 'COMPLETED', 'CANCELLED']
                .map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    ))
                .toList(),
          ],
          onChanged: onStatusBookChanged,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: pickupStatus,
          decoration: InputDecoration(
            labelText: 'booking.pickup_status'.tr(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: [
            DropdownMenuItem<String>(
              value: null,
              child: Text('common.none'.tr()),
            ),
            ...['YET', 'PICKED', 'INWAY']
                .map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    ))
                .toList(),
          ],
          onChanged: onPickupStatusChanged,
        ),
        const SizedBox(height: 16),
        if (loadingAgents)
          const CircularProgressIndicator()
        else
          DropdownButtonFormField<int>(
            value: agentId,
            decoration: InputDecoration(
              labelText: 'booking.agent_name'.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            items: [
              DropdownMenuItem<int>(
                value: null,
                child: Text('common.all'.tr()),
              ),
              ...agents.map((agent) => DropdownMenuItem(
                    value: agent.id,
                    child: Text(agent.name),
                  )),
            ],
            onChanged: onAgentIdChanged,
          ),
      ],
    );
  }
}

