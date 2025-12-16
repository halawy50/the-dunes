import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class EmployeeHeaderActions extends StatelessWidget {
  const EmployeeHeaderActions({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        context.push('/employees/new');
      },
      icon: const Icon(Icons.add, size: 18),
      label: Text('employees.new_employee'.tr()),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.YELLOW,
        foregroundColor: AppColor.WHITE,
      ),
    );
  }
}
