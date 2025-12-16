import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/features/employees/domain/entities/commission_entity.dart';
import 'package:the_dunes/features/employees/domain/entities/employee_entity.dart';

class EmployeeCommissionPayContent extends StatelessWidget {
  final CommissionEntity commission;
  final EmployeeEntity employee;
  final TextEditingController noteController;

  const EmployeeCommissionPayContent({
    super.key,
    required this.commission,
    required this.employee,
    required this.noteController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'employees.pay_commission_message'.tr(
            namedArgs: {
              'amount': commission.amount.toStringAsFixed(2),
              'name': employee.name,
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

