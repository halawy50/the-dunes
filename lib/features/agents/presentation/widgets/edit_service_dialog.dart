import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/features/agents/domain/entities/service_agent_entity.dart';
import 'package:the_dunes/features/agents/presentation/widgets/edit_service_dialog_callbacks.dart';
import 'package:the_dunes/features/agents/presentation/widgets/edit_service_dialog_content.dart';
import 'package:the_dunes/features/agents/presentation/widgets/edit_service_dialog_data_loader.dart';
import 'package:the_dunes/features/agents/presentation/widgets/edit_service_dialog_state.dart';
import 'package:the_dunes/features/agents/presentation/widgets/edit_service_dialog_submit_handler.dart';

class EditServiceDialog extends StatefulWidget {
  final ServiceAgentEntity service;
  final int agentId;

  const EditServiceDialog({
    super.key,
    required this.service,
    required this.agentId,
  });

  @override
  State<EditServiceDialog> createState() => _EditServiceDialogState();
}

class _EditServiceDialogState extends State<EditServiceDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _adultPriceController;
  late final TextEditingController _childPriceController;
  late final TextEditingController _kidPriceController;
  var _state = EditServiceDialogState();
  late final _callbacks = EditServiceDialogCallbacks(
    getState: () => _state,
    setState: (state) => setState(() => _state = state),
  );

  @override
  void initState() {
    super.initState();
    _adultPriceController = TextEditingController(
      text: widget.service.adultPrice.toStringAsFixed(2),
    );
    _childPriceController = TextEditingController(
      text: widget.service.childPrice?.toStringAsFixed(2) ?? '',
    );
    _kidPriceController = TextEditingController(
      text: widget.service.kidPrice?.toStringAsFixed(2) ?? '',
    );
    _loadData();
  }

  Future<void> _loadData() async {
    final newState = await EditServiceDialogDataLoader.loadInitialState(
      widget.service,
    );
    setState(() => _state = newState);
  }

  @override
  void dispose() {
    _adultPriceController.dispose();
    _childPriceController.dispose();
    _kidPriceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await EditServiceDialogSubmitHandler.submit(
      context: context,
      formKey: _formKey,
      serviceId: widget.service.id,
      agentId: widget.agentId,
      adultPriceController: _adultPriceController,
      childPriceController: _childPriceController,
      kidPriceController: _kidPriceController,
      isGlobal: _state.isGlobal,
      selectedLocation: _state.selectedLocation,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('agents.edit_service'.tr()),
      content: EditServiceDialogContent(
        service: widget.service,
        formKey: _formKey,
        state: _state,
        adultPriceController: _adultPriceController,
        childPriceController: _childPriceController,
        kidPriceController: _kidPriceController,
        onGlobalChanged: _callbacks.onGlobalChanged,
        onLocationChanged: _callbacks.onLocationChanged,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('common.cancel'.tr()),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text('common.save'.tr()),
        ),
      ],
    );
  }
}

