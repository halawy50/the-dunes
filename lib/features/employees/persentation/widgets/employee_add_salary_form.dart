import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_salary_month_helper.dart';

class EmployeeAddSalaryForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController yearController;
  final TextEditingController salaryController;
  final String? selectedMonth;
  final void Function(String?) onMonthChanged;

  const EmployeeAddSalaryForm({
    super.key,
    required this.formKey,
    required this.yearController,
    required this.salaryController,
    required this.selectedMonth,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    final months = EmployeeSalaryMonthHelper.getMonths();

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: yearController,
              decoration: InputDecoration(
                labelText: 'employees.year'.tr(),
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'employees.year_required'.tr();
                }
                if (int.tryParse(value) == null) {
                  return 'employees.year_invalid'.tr();
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedMonth,
              decoration: InputDecoration(
                labelText: 'employees.month'.tr(),
                border: const OutlineInputBorder(),
              ),
              items: months.map((month) {
                return DropdownMenuItem(
                  value: month,
                  child: Text(month),
                );
              }).toList(),
              onChanged: onMonthChanged,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'employees.month_required'.tr();
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: salaryController,
              decoration: InputDecoration(
                labelText: 'employees.sallery'.tr(),
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'employees.salary_required'.tr();
                }
                final salary = double.tryParse(value);
                if (salary == null || salary <= 0) {
                  return 'employees.salary_invalid'.tr();
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}

