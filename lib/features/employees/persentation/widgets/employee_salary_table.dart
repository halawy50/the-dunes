import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_cell_factory.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_widget.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/employees/domain/entities/salary_entity.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_salary_actions_cell.dart';

class EmployeeSalaryTable extends StatelessWidget {
  final List<SalaryEntity> salaries;
  final void Function(int) onPaySalary;
  final void Function(SalaryEntity) onEditSalary;
  final void Function(int) onDeleteSalary;
  final int? payingSalaryId;

  const EmployeeSalaryTable({
    super.key,
    required this.salaries,
    required this.onPaySalary,
    required this.onEditSalary,
    required this.onDeleteSalary,
    this.payingSalaryId,
  });

  @override
  Widget build(BuildContext context) {
    final columns = _buildColumns();

    return BaseTableWidget<SalaryEntity>(
      key: ValueKey('salaries_${salaries.length}'),
      columns: columns,
      data: salaries,
      showCheckbox: false,
    );
  }

  List<BaseTableColumn<SalaryEntity>> _buildColumns() {
    return [
      BaseTableColumn<SalaryEntity>(
        headerKey: 'employees.year',
        width: 100,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.year,
        ),
      ),
      BaseTableColumn<SalaryEntity>(
        headerKey: 'employees.month',
        width: 120,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.month,
        ),
      ),
      BaseTableColumn<SalaryEntity>(
        headerKey: 'employees.sallery',
        width: 150,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: '${item.salary.toStringAsFixed(2)} AED',
        ),
      ),
      BaseTableColumn<SalaryEntity>(
        headerKey: 'employees.status',
        width: 120,
        cellBuilder: (item, index) {
          Color statusColor;
          String statusText;
          if (item.statusPaid == 'PAID') {
            statusColor = Colors.green;
            statusText = 'employees.paid'.tr();
          } else if (item.statusPaid == 'OVERDUE') {
            statusColor = Colors.red;
            statusText = 'employees.overdue'.tr();
          } else {
            statusColor = AppColor.YELLOW;
            statusText = 'employees.pending'.tr();
          }
          return BaseTableCellFactory.status(
            status: statusText,
            color: statusColor,
          );
        },
      ),
      BaseTableColumn<SalaryEntity>(
        headerKey: 'employees.actions',
        width: 200,
        cellBuilder: (item, index) {
          return EmployeeSalaryActionsCell(
            salary: item,
            isPaying: payingSalaryId == item.id,
            onPaySalary: () => onPaySalary(item.id),
            onEditSalary: () => onEditSalary(item),
            onDeleteSalary: () => onDeleteSalary(item.id),
          );
        },
      ),
    ];
  }
}



