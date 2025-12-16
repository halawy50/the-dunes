import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/features/agents/presentation/cubit/agent_detail_cubit.dart';
import 'package:the_dunes/features/booking/data/models/location_model.dart';

class EditServiceDialogSubmitHandler {
  static Future<void> submit({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required int serviceId,
    required int agentId,
    required TextEditingController adultPriceController,
    required TextEditingController childPriceController,
    required TextEditingController kidPriceController,
    required bool isGlobal,
    LocationModel? selectedLocation,
  }) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final cubit = context.read<AgentDetailCubit>();
    await cubit.updateService(
      id: serviceId,
      agentId: agentId,
      locationId: isGlobal ? null : selectedLocation?.id,
      adultPrice: double.parse(adultPriceController.text),
      childPrice: childPriceController.text.isNotEmpty
          ? double.parse(childPriceController.text)
          : null,
      kidPrice: kidPriceController.text.isNotEmpty
          ? double.parse(kidPriceController.text)
          : null,
    );

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

