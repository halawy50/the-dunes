import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/features/employees/domain/entities/employee_entity.dart';

class EmployeeResetPasswordForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final EmployeeEntity employee;

  const EmployeeResetPasswordForm({
    super.key,
    required this.formKey,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.employee,
  });

  @override
  State<EmployeeResetPasswordForm> createState() => _EmployeeResetPasswordFormState();
}

class _EmployeeResetPasswordFormState extends State<EmployeeResetPasswordForm> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('employees.reset_password_message'.tr(
              namedArgs: {'name': widget.employee.name},
            )),
            const SizedBox(height: 16),
            TextFormField(
              controller: widget.passwordController,
              decoration: InputDecoration(
                labelText: 'employees.new_password'.tr(),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              obscureText: _obscurePassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'employees.password_required'.tr();
                }
                if (value.length < 6) {
                  return 'employees.password_min_length'.tr();
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: widget.confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'employees.confirm_password'.tr(),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                ),
              ),
              obscureText: _obscureConfirmPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'employees.confirm_password_required'.tr();
                }
                if (value != widget.passwordController.text) {
                  return 'employees.passwords_not_match'.tr();
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

