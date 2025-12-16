import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/employees/domain/entities/commission_entity.dart';
import 'package:the_dunes/features/employees/domain/entities/employee_entity.dart';
import 'package:the_dunes/features/employees/persentation/cubit/employee_detail_cubit.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_commission_pay_content.dart';

class EmployeeCommissionPayDialog {
  static void show(
    BuildContext context,
    CommissionEntity commission,
    EmployeeEntity employee,
  ) {
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('common.are_you_sure'.tr()),
        content: EmployeeCommissionPayContent(
          commission: commission,
          employee: employee,
          noteController: noteController,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('common.cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              final note = noteController.text.trim().isEmpty
                  ? null
                  : noteController.text.trim();
              context
                  .read<EmployeeDetailCubit>()
                  .payCommission(commission.id, note: note);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.YELLOW,
            ),
            child: Text('employees.pay'.tr()),
          ),
        ],
      ),
    );
  }
}

