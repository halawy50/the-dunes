import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/employees/domain/entities/salary_entity.dart';

class EmployeeSalaryActionsCell extends StatelessWidget {
  final SalaryEntity salary;
  final bool isPaying;
  final VoidCallback? onPaySalary;
  final VoidCallback? onEditSalary;
  final VoidCallback? onDeleteSalary;

  const EmployeeSalaryActionsCell({
    super.key,
    required this.salary,
    required this.isPaying,
    this.onPaySalary,
    this.onEditSalary,
    this.onDeleteSalary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (salary.statusPaid != 'PAID')
          Flexible(
            child: ElevatedButton(
              onPressed: isPaying ? null : onPaySalary,
              style: ElevatedButton.styleFrom(
                backgroundColor: isPaying ? Colors.grey : AppColor.YELLOW,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              child: isPaying
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColor.WHITE),
                      ),
                    )
                  : FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('employees.paid_sallery'.tr()),
                    ),
            ),
          ),
        if (salary.statusPaid != 'PAID') const SizedBox(width: 4),
        Flexible(
          child: IconButton(
            onPressed: isPaying ? null : onEditSalary,
            icon: const Icon(Icons.edit, size: 18),
            color: AppColor.YELLOW,
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: IconButton(
            onPressed: isPaying ? null : onDeleteSalary,
            icon: const Icon(Icons.delete, size: 18),
            color: Colors.red,
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
          ),
        ),
      ],
    );
  }
}

