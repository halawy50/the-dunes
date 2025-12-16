import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ReceiptVoucherFilterFormFields extends StatelessWidget {
  final TextEditingController guestNameController;
  final String? status;
  final Function(String?) onStatusChanged;

  const ReceiptVoucherFilterFormFields({
    super.key,
    required this.guestNameController,
    required this.status,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: guestNameController,
          decoration: InputDecoration(
            labelText: 'receipt_voucher.guest_name'.tr(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: status,
          decoration: InputDecoration(
            labelText: 'receipt_voucher.status'.tr(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: [
            DropdownMenuItem<String>(
              value: null,
              child: Text('common.none'.tr()),
            ),
            ...['PENDING', 'ACCEPTED', 'COMPLETED', 'CANCELLED']
                .map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    ))
                .toList(),
          ],
          onChanged: onStatusChanged,
        ),
      ],
    );
  }
}

