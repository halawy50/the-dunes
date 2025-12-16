import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/features/employees/domain/entities/commission_entity.dart';

class EmployeeCommissionBulkPayContent extends StatelessWidget {
  final List<CommissionEntity> selectedCommissions;
  final TextEditingController noteController;

  const EmployeeCommissionBulkPayContent({
    super.key,
    required this.selectedCommissions,
    required this.noteController,
  });

  @override
  Widget build(BuildContext context) {
    final totalAmount = selectedCommissions.fold<double>(
      0.0,
      (sum, c) => sum + c.amount,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'employees.bulk_pay_message'.tr(
            namedArgs: {
              'count': selectedCommissions.length.toString(),
              'amount': totalAmount.toStringAsFixed(2),
            },
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: noteController,
          decoration: InputDecoration(
            labelText: 'employees.payment_note'.tr(),
            hintText: 'employees.payment_note_hint'.tr(),
            border: const OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }
}

