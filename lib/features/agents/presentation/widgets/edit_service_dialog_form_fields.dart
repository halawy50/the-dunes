import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/features/agents/presentation/widgets/edit_service_dialog_state.dart';
import 'package:the_dunes/features/booking/data/models/location_model.dart';

class EditServiceDialogFormFields extends StatelessWidget {
  final EditServiceDialogState state;
  final TextEditingController adultPriceController;
  final TextEditingController childPriceController;
  final TextEditingController kidPriceController;
  final void Function(bool) onGlobalChanged;
  final void Function(LocationModel?) onLocationChanged;

  const EditServiceDialogFormFields({
    super.key,
    required this.state,
    required this.adultPriceController,
    required this.childPriceController,
    required this.kidPriceController,
    required this.onGlobalChanged,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          title: Text('agents.global_service'.tr()),
          value: state.isGlobal,
          onChanged: (value) => onGlobalChanged(value ?? true),
        ),
        if (!state.isGlobal) ...[
          const SizedBox(height: 8),
          DropdownButtonFormField<LocationModel>(
            value: state.selectedLocation,
            decoration: InputDecoration(
              labelText: 'agents.select_location'.tr(),
            ),
            items: state.locations
                .map((location) => DropdownMenuItem(
                      value: location,
                      child: Text(location.name),
                    ))
                .toList(),
            onChanged: onLocationChanged,
          ),
        ],
        const SizedBox(height: 16),
        TextFormField(
          controller: adultPriceController,
          decoration: InputDecoration(
            labelText: 'agents.adult_price'.tr(),
            prefixText: 'common.required'.tr(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'agents.adult_price_required'.tr();
            }
            if (double.tryParse(value) == null) {
              return 'errors.invalid_number'.tr();
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
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              if (double.tryParse(value) == null) {
                return 'errors.invalid_number'.tr();
              }
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: kidPriceController,
          decoration: InputDecoration(
            labelText: 'agents.kid_price'.tr(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              if (double.tryParse(value) == null) {
                return 'errors.invalid_number'.tr();
              }
            }
            return null;
          },
        ),
      ],
    );
  }
}
