import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/employees/domain/entities/employee_entity.dart';
import 'package:the_dunes/features/employees/domain/entities/salary_entity.dart';
import 'package:the_dunes/features/employees/persentation/cubit/employee_detail_cubit.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_add_salary_dialog.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_edit_salary_dialog.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_salary_table.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_salary_dialogs.dart';

class EmployeeSalaryTab extends StatelessWidget {
  final EmployeeEntity employee;
  final List<SalaryEntity> salaries;

  const EmployeeSalaryTab({
    super.key,
    required this.employee,
    required this.salaries,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'employees.sallery'.tr(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (employee.isSalary)
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) => BlocProvider.value(
                          value: context.read<EmployeeDetailCubit>(),
                          child: EmployeeAddSalaryDialog(
                            employee: employee,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.YELLOW,
                    ),
                    child: Text('employees.add_salary'.tr()),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            BlocBuilder<EmployeeDetailCubit, EmployeeDetailState>(
              builder: (context, state) {
                final payingSalaryId = state is EmployeeDetailLoaded
                    ? state.payingSalaryId
                    : null;
                return EmployeeSalaryTable(
                  salaries: salaries,
                  onPaySalary: (salaryId) {
                    final salary = salaries.firstWhere((s) => s.id == salaryId);
                    EmployeeSalaryDialogs.showPaySalaryDialog(
                      context,
                      salary,
                      employee,
                    );
                  },
                  onEditSalary: (salary) {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => BlocProvider.value(
                        value: context.read<EmployeeDetailCubit>(),
                        child: EmployeeEditSalaryDialog(salary: salary),
                      ),
                    );
                  },
                  onDeleteSalary: (salaryId) {
                    final salary = salaries.firstWhere((s) => s.id == salaryId);
                    EmployeeSalaryDialogs.showDeleteSalaryDialog(context, salary);
                  },
                  payingSalaryId: payingSalaryId,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

}



