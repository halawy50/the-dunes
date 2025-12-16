import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/employees/domain/entities/employee_entity.dart';
import 'package:the_dunes/features/employees/persentation/cubit/employee_detail_cubit.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_add_salary_form.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_salary_month_helper.dart';

class EmployeeAddSalaryDialog extends StatefulWidget {
  final EmployeeEntity employee;

  const EmployeeAddSalaryDialog({
    super.key,
    required this.employee,
  });

  @override
  State<EmployeeAddSalaryDialog> createState() => _EmployeeAddSalaryDialogState();
}

class _EmployeeAddSalaryDialogState extends State<EmployeeAddSalaryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _yearController = TextEditingController();
  final _salaryController = TextEditingController();
  String? _selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _yearController.text = now.year.toString();
    _selectedMonth = EmployeeSalaryMonthHelper.getMonthName(now.month);
  }

  @override
  void dispose() {
    _yearController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  void _handleSubmit(BuildContext dialogContext) {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedMonth == null) {
      AppSnackbar.show(
        context: dialogContext,
        message: 'employees.month_required'.tr(),
        type: SnackbarType.error,
      );
      return;
    }

    final data = {
      'employeeId': widget.employee.id,
      'year': _yearController.text.trim(),
      'month': _selectedMonth!,
      'salary': double.parse(_salaryController.text.trim()),
    };

    Navigator.pop(dialogContext);
    try {
      dialogContext.read<EmployeeDetailCubit>().createSalary(data);
    } catch (e) {
      AppSnackbar.show(
        context: dialogContext,
        message: e.toString().replaceAll('ApiException: ', ''),
        type: SnackbarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('employees.add_salary'.tr()),
          content: EmployeeAddSalaryForm(
            formKey: _formKey,
            yearController: _yearController,
            salaryController: _salaryController,
            selectedMonth: _selectedMonth,
            onMonthChanged: (value) {
              setState(() {
                _selectedMonth = value;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('common.cancel'.tr()),
            ),
            ElevatedButton(
              onPressed: () => _handleSubmit(dialogContext),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.YELLOW,
              ),
              child: Text('common.add'.tr()),
            ),
          ],
        );
      },
    );
  }
}

