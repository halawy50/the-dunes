import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/features/agents/presentation/cubit/agent_detail_cubit.dart';
import 'package:the_dunes/features/agents/presentation/widgets/add_service_dialog_actions.dart';
import 'package:the_dunes/features/agents/presentation/widgets/add_service_dialog_callbacks.dart';
import 'package:the_dunes/features/agents/presentation/widgets/add_service_dialog_content.dart';
import 'package:the_dunes/features/agents/presentation/widgets/add_service_dialog_logic.dart';
import 'package:the_dunes/features/agents/presentation/widgets/add_service_dialog_state.dart';
import 'package:the_dunes/features/agents/presentation/widgets/add_service_dialog_submit_handler.dart';
import 'package:the_dunes/features/booking/data/models/location_model.dart';
import 'package:the_dunes/features/booking/data/models/service_model.dart';

class AddServiceDialog extends StatefulWidget {
  final int agentId;
  final AgentDetailCubit? cubit;

  const AddServiceDialog({
    super.key,
    required this.agentId,
    this.cubit,
  });

  @override
  State<AddServiceDialog> createState() => _AddServiceDialogState();
}

class _AddServiceDialogState extends State<AddServiceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _adultPriceController = TextEditingController();
  final _childPriceController = TextEditingController();
  final _kidPriceController = TextEditingController();
  var _state = AddServiceDialogState();
  late final _callbacks = AddServiceDialogCallbacks(
    getState: () => _state,
    setState: (state) => setState(() => _state = state),
  );

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final result = await AddServiceDialogLogic.loadData();
    setState(() {
      _state = _state.copyWith(
        services: (result['services'] as List).cast<ServiceModel>(),
        locations: (result['locations'] as List).cast<LocationModel>(),
        isLoading: false,
      );
    });
  }

  @override
  void dispose() {
    _adultPriceController.dispose();
    _childPriceController.dispose();
    _kidPriceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final success = await AddServiceDialogSubmitHandler.submit(
      context: context,
      formKey: _formKey,
      selectedService: _state.selectedService,
      isGlobal: _state.isGlobal,
      selectedLocation: _state.selectedLocation,
      agentId: widget.agentId,
      adultPriceController: _adultPriceController,
      childPriceController: _childPriceController,
      kidPriceController: _kidPriceController,
      cubit: widget.cubit,
    );
    if (mounted && success) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('agents.add_service'.tr()),
      content: AddServiceDialogContent(
        state: _state,
        formKey: _formKey,
        adultPriceController: _adultPriceController,
        childPriceController: _childPriceController,
        kidPriceController: _kidPriceController,
        onServiceChanged: _callbacks.onServiceChanged,
        onGlobalChanged: _callbacks.onGlobalChanged,
        onLocationChanged: _callbacks.onLocationChanged,
      ),
      actions: AddServiceDialogActions(
        onCancel: () => Navigator.of(context).pop(),
        onSubmit: _submit,
      ).buildActions(),
    );
  }
}

