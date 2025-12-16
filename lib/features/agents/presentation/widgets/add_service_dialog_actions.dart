import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AddServiceDialogActions extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  const AddServiceDialogActions({
    super.key,
    required this.onCancel,
    required this.onSubmit,
  });

  List<Widget> buildActions() {
    return [
      TextButton(
        onPressed: onCancel,
        child: Text('common.cancel'.tr()),
      ),
      ElevatedButton(
        onPressed: onSubmit,
        child: Text('common.save'.tr()),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

