import 'package:flutter/material.dart';
import 'package:the_dunes/features/agents/presentation/widgets/add_service_dialog_form_fields.dart';
import 'package:the_dunes/features/agents/presentation/widgets/add_service_dialog_state.dart';
import 'package:the_dunes/features/booking/data/models/location_model.dart';
import 'package:the_dunes/features/booking/data/models/service_model.dart';

class AddServiceDialogContent extends StatelessWidget {
  final AddServiceDialogState state;
  final GlobalKey<FormState> formKey;
  final TextEditingController adultPriceController;
  final TextEditingController childPriceController;
  final TextEditingController kidPriceController;
  final void Function(ServiceModel?) onServiceChanged;
  final void Function(bool) onGlobalChanged;
  final void Function(LocationModel?) onLocationChanged;

  const AddServiceDialogContent({
    super.key,
    required this.state,
    required this.formKey,
    required this.adultPriceController,
    required this.childPriceController,
    required this.kidPriceController,
    required this.onServiceChanged,
    required this.onGlobalChanged,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const CircularProgressIndicator();
    }
    return SizedBox(
      width: 400,
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: AddServiceDialogFormFields(
            selectedService: state.selectedService,
            selectedLocation: state.selectedLocation,
            isGlobal: state.isGlobal,
            services: state.services,
            locations: state.locations,
            adultPriceController: adultPriceController,
            childPriceController: childPriceController,
            kidPriceController: kidPriceController,
            onServiceChanged: onServiceChanged,
            onGlobalChanged: onGlobalChanged,
            onLocationChanged: onLocationChanged,
          ),
        ),
      ),
    );
  }
}


