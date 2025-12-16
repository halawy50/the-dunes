import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_model.dart';

class ReceiptVoucherEditDialog extends StatelessWidget {
  final ReceiptVoucherModel voucher;
  final void Function(Map<String, dynamic>) onSave;

  const ReceiptVoucherEditDialog({
    super.key,
    required this.voucher,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('receipt_voucher.title'.tr()),
      content: Text('receipt_voucher.edit_dialog_placeholder'.tr()),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('common.cancel'.tr()),
        ),
        TextButton(
          onPressed: () {
            onSave({});
            Navigator.of(context).pop();
          },
          child: Text('common.save'.tr()),
        ),
      ],
    );
  }
}

