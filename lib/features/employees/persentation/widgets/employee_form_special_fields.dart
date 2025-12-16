import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/features/employees/persentation/cubit/new_employee_cubit.dart';

class EmployeeFormSpecialFields {
  static Widget buildCommissionField(
    BuildContext context,
    NewEmployeeCubit cubit,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'employees.commission_rate'.tr() + ' *',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Directionality(
          textDirection: ui.TextDirection.ltr,
          child: TextField(
            controller: TextEditingController(
              text: cubit.commission?.toString() ?? '',
            ),
            onChanged: (value) => cubit.updateCommission(double.tryParse(value)),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixText: '%',
            ),
          ),
        ),
      ],
    );
  }

  static Widget buildVisaCostField(
    BuildContext context,
    NewEmployeeCubit cubit,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'employees.staff_visa_cost'.tr() + ' *',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Directionality(
          textDirection: ui.TextDirection.ltr,
          child: TextField(
            controller: TextEditingController(
              text: cubit.visaCost?.toString() ?? '',
            ),
            onChanged: (value) => cubit.updateVisaCost(double.tryParse(value)),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixText: 'AED',
            ),
          ),
        ),
      ],
    );
  }
}



