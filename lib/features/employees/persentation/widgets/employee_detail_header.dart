import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/employees/domain/entities/employee_entity.dart';
import 'package:the_dunes/features/employees/persentation/cubit/employee_detail_cubit.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_reset_password_dialog.dart';

class EmployeeDetailHeader extends StatelessWidget {
  final EmployeeEntity employee;

  const EmployeeDetailHeader({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColor.WHITE,
        boxShadow: [
          BoxShadow(
            color: Color(0x14323232),
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/employees');
              }
            },
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 30,
            backgroundImage: employee.image != null
                ? NetworkImage(employee.image!)
                : null,
            backgroundColor: AppColor.YELLOW,
            child: employee.image == null
                ? Text(
                    employee.name.isNotEmpty ? employee.name[0].toUpperCase() : 'E',
                    style: const TextStyle(
                      color: AppColor.BLACK,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  employee.position ?? '-',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColor.GRAY_HULF,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.lock_reset),
            tooltip: 'employees.reset_password'.tr(),
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogContext) => BlocProvider.value(
                  value: context.read<EmployeeDetailCubit>(),
                  child: EmployeeResetPasswordDialog(employee: employee),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

