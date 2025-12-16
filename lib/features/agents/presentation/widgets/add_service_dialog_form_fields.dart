import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/features/booking/data/models/location_model.dart';
import 'package:the_dunes/features/booking/data/models/service_model.dart';

class AddServiceDialogFormFields extends StatelessWidget {
  final ServiceModel? selectedService;
  final LocationModel? selectedLocation;
  final bool isGlobal;
  final List<ServiceModel> services;
  final List<LocationModel> locations;
  final TextEditingController adultPriceController;
  final TextEditingController childPriceController;
  final TextEditingController kidPriceController;
  final Function(ServiceModel?) onServiceChanged;
  final Function(bool) onGlobalChanged;
  final Function(LocationModel?) onLocationChanged;

  const AddServiceDialogFormFields({
    super.key,
    required this.selectedService,
    required this.selectedLocation,
    required this.isGlobal,
    required this.services,
    required this.locations,
    required this.adultPriceController,
    required this.childPriceController,
    required this.kidPriceController,
    required this.onServiceChanged,
    required this.onGlobalChanged,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonFormField<ServiceModel>(
          value: selectedService,
          decoration: InputDecoration(
            labelText: '${'agents.select_service'.tr()} ${'common.required'.tr()}',
          ),
          items: services.map((service) {
            return DropdownMenuItem(
              value: service,
              child: Text(service.name),
            );
          }).toList(),
          onChanged: onServiceChanged,
          validator: (value) {
            if (value == null) {
              return 'agents.service_required'.tr();
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: Text('agents.global_service'.tr()),
          value: isGlobal,
          onChanged: (value) => onGlobalChanged(value ?? true),
        ),
        if (!isGlobal) ...[
          const SizedBox(height: 8),
          DropdownButtonFormField<LocationModel>(
            value: selectedLocation,
            decoration: InputDecoration(
              labelText: 'agents.select_location'.tr(),
            ),
            items: locations.map((location) {
              return DropdownMenuItem(
                value: location,
                child: Text(location.name),
              );
            }).toList(),
            onChanged: onLocationChanged,
          ),
        ],
        const SizedBox(height: 16),
        TextFormField(
          controller: adultPriceController,
          decoration: InputDecoration(
            labelText: '${'agents.adult_price'.tr()} ${'common.required'.tr()}',
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'agents.adult_price_required'.tr();
            }
            if (double.tryParse(value) == null) {
              return 'Invalid number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: childPriceController,
          decoration: InputDecoration(
            labelText: 'agents.child_price'.tr(),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: kidPriceController,
          decoration: InputDecoration(
            labelText: 'agents.kid_price'.tr(),
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}


