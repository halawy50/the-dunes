import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/employees/domain/entities/employee_entity.dart';
import 'package:the_dunes/features/employees/domain/entities/salary_entity.dart';
import 'package:the_dunes/features/employees/persentation/cubit/employee_detail_cubit.dart';

class EmployeeSalaryDialogs {
  static void showPaySalaryDialog(
    BuildContext context,
    SalaryEntity salary,
    EmployeeEntity employee,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('common.are_you_sure'.tr()),
        content: Text(
          'employees.pay_salary_message'.tr(
            namedArgs: {
              'amount': salary.salary.toStringAsFixed(2),
              'name': employee.name,
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('common.no'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<EmployeeDetailCubit>().paySalary(salary.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.YELLOW,
            ),
            child: Text('common.yes'.tr()),
          ),
        ],
      ),
    );
  }

  static void showDeleteSalaryDialog(
    BuildContext context,
    SalaryEntity salary,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('common.delete_confirmation'.tr()),
        content: Text('employees.delete_salary_message'.tr(
          namedArgs: {
            'month': salary.month,
            'year': salary.year,
          },
        )),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('common.no'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<EmployeeDetailCubit>().deleteSalary(salary.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('common.yes'.tr()),
          ),
        ],
      ),
    );
  }
}

