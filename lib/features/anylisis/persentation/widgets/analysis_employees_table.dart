import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/anylisis/domain/entities/employee_with_vouchers_entity.dart';

class AnalysisEmployeesTable extends StatelessWidget {
  final EmployeesWithVouchersEntity employeesWithVouchers;

  const AnalysisEmployeesTable({
    super.key,
    required this.employeesWithVouchers,
  });

  @override
  Widget build(BuildContext context) {
    if (employeesWithVouchers.employees.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      color: AppColor.WHITE,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'analysis.employees'.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.go('/employees');
                  },
                  child: Text('analysis.see_all'.tr()),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DataTable(
              columns: [
                DataColumn(
                  label: Text('analysis.table.name'.tr()),
                ),
                DataColumn(
                  label: Text('analysis.table.number_vouchers'.tr()),
                ),
              ],
              rows: employeesWithVouchers.employees.map((employee) {
                return DataRow(
                  cells: [
                    DataCell(Text(employee.employeeName)),
                    DataCell(Text(employee.voucherCount.toString())),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

