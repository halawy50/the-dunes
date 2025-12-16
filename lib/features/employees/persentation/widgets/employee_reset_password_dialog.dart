import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/employees/domain/entities/employee_entity.dart';
import 'package:the_dunes/features/employees/persentation/cubit/employee_detail_cubit.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_reset_password_form.dart';

class EmployeeResetPasswordDialog extends StatefulWidget {
  final EmployeeEntity employee;

  const EmployeeResetPasswordDialog({
    super.key,
    required this.employee,
  });

  @override
  State<EmployeeResetPasswordDialog> createState() => _EmployeeResetPasswordDialogState();
}

class _EmployeeResetPasswordDialogState extends State<EmployeeResetPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(BuildContext dialogContext) async {
    if (!_formKey.currentState!.validate()) return;

    final newPassword = _passwordController.text.trim();
    Navigator.pop(dialogContext);
    
    try {
      final result = await dialogContext.read<EmployeeDetailCubit>().resetPassword(
        employeeId: widget.employee.id,
        newPassword: newPassword,
      );
      
      if (result != null && result['newPassword'] != null && dialogContext.mounted) {
        AppSnackbar.show(
          context: dialogContext,
          message: 'employees.password_reset_success'.tr(
            namedArgs: {
              'password': result['newPassword'] as String,
            },
          ),
          type: SnackbarType.success,
        );
      }
    } catch (e) {
      if (dialogContext.mounted) {
        AppSnackbar.show(
          context: dialogContext,
          message: e.toString().replaceAll('ApiException: ', ''),
          type: SnackbarType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (dialogContext) => AlertDialog(
        title: Text('employees.reset_password'.tr()),
        content: EmployeeResetPasswordForm(
          formKey: _formKey,
          passwordController: _passwordController,
          confirmPasswordController: _confirmPasswordController,
          employee: widget.employee,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('common.cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () => _handleSubmit(dialogContext),
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.YELLOW),
            child: Text('common.reset'.tr()),
          ),
        ],
      ),
    );
  }
}

