import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/features/agents/presentation/cubit/agent_detail_cubit.dart';
import 'package:the_dunes/features/booking/data/models/location_model.dart';
import 'package:the_dunes/features/booking/data/models/service_model.dart';

class AddServiceDialogSubmitHandler {
  static Future<bool> submit({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required ServiceModel? selectedService,
    required bool isGlobal,
    required LocationModel? selectedLocation,
    required int agentId,
    required TextEditingController adultPriceController,
    required TextEditingController childPriceController,
    required TextEditingController kidPriceController,
    AgentDetailCubit? cubit,
  }) async {
    if (!formKey.currentState!.validate() || selectedService == null) {
      return false;
    }

    if (!isGlobal && selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('agents.location_required'.tr())),
      );
      return false;
    }

    AgentDetailCubit finalCubit;
    if (cubit != null) {
      finalCubit = cubit;
    } else {
      try {
        finalCubit = context.read<AgentDetailCubit>();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Unable to access agent cubit')),
        );
        return false;
      }
    }
    await finalCubit.createService(
      agentId: agentId,
      serviceId: selectedService.id,
      locationId: isGlobal ? null : selectedLocation?.id,
      adultPrice: double.parse(adultPriceController.text),
      childPrice: childPriceController.text.isNotEmpty
          ? double.parse(childPriceController.text)
          : null,
      kidPrice: kidPriceController.text.isNotEmpty
          ? double.parse(kidPriceController.text)
          : null,
    );
    return true;
  }
}

