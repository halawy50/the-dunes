import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/features/agents/domain/entities/service_agent_entity.dart';
import 'package:the_dunes/features/agents/presentation/widgets/edit_service_dialog_form_fields.dart';
import 'package:the_dunes/features/agents/presentation/widgets/edit_service_dialog_state.dart';
import 'package:the_dunes/features/booking/data/models/location_model.dart';

class EditServiceDialogContent extends StatelessWidget {
  final ServiceAgentEntity service;
  final GlobalKey<FormState> formKey;
  final EditServiceDialogState state;
  final TextEditingController adultPriceController;
  final TextEditingController childPriceController;
  final TextEditingController kidPriceController;
  final void Function(bool) onGlobalChanged;
  final void Function(LocationModel?) onLocationChanged;

  const EditServiceDialogContent({
    super.key,
    required this.service,
    required this.formKey,
    required this.state,
    required this.adultPriceController,
    required this.childPriceController,
    required this.kidPriceController,
    required this.onGlobalChanged,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const SizedBox(
        width: 400,
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      width: 400,
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${'agents.service_name'.tr()}: ${service.serviceName ?? '-'}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              EditServiceDialogFormFields(
                state: state,
                adultPriceController: adultPriceController,
                childPriceController: childPriceController,
                kidPriceController: kidPriceController,
                onGlobalChanged: onGlobalChanged,
                onLocationChanged: onLocationChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

