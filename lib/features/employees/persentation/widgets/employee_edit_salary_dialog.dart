import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/employees/domain/entities/salary_entity.dart';
import 'package:the_dunes/features/employees/persentation/cubit/employee_detail_cubit.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_add_salary_form.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_edit_salary_helper.dart';

class EmployeeEditSalaryDialog extends StatefulWidget {
  final SalaryEntity salary;

  const EmployeeEditSalaryDialog({
    super.key,
    required this.salary,
  });

  @override
  State<EmployeeEditSalaryDialog> createState() => _EmployeeEditSalaryDialogState();
}

class _EmployeeEditSalaryDialogState extends State<EmployeeEditSalaryDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _yearController;
  late final TextEditingController _salaryController;
  late String? _selectedMonth;

  @override
  void initState() {
    super.initState();
    _yearController = TextEditingController(text: widget.salary.year);
    _salaryController = TextEditingController(text: widget.salary.salary.toStringAsFixed(2));
    _selectedMonth = widget.salary.month;
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
    final newSalary = double.parse(_salaryController.text.trim());
    final data = EmployeeEditSalaryHelper.buildUpdateData(
      salary: widget.salary,
      year: _yearController.text.trim(),
      month: _selectedMonth!,
      salaryAmount: newSalary,
    );
    if (data.isEmpty) {
      Navigator.pop(dialogContext);
      return;
    }
    Navigator.pop(dialogContext);
    try {
      dialogContext.read<EmployeeDetailCubit>().updateSalary(widget.salary.id, data);
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
      builder: (dialogContext) => AlertDialog(
        title: Text('employees.edit_salary'.tr()),
        content: EmployeeAddSalaryForm(
          formKey: _formKey,
          yearController: _yearController,
          salaryController: _salaryController,
          selectedMonth: _selectedMonth,
          onMonthChanged: (value) => setState(() => _selectedMonth = value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('common.cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () => _handleSubmit(dialogContext),
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.YELLOW),
            child: Text('common.save'.tr()),
          ),
        ],
      ),
    );
  }
}
