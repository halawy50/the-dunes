import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_config.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_widget.dart';
import 'package:the_dunes/core/widgets/base_table/employees/employee_table_columns.dart';
import 'package:the_dunes/features/employees/domain/entities/employee_entity.dart';

class EmployeeTableWidget extends StatelessWidget {
  const EmployeeTableWidget({
    super.key,
    required this.employees,
  });

  final List<EmployeeEntity> employees;

  @override
  Widget build(BuildContext context) {
    final columns = EmployeeTableColumns.buildColumns();

    return BaseTableWidget<EmployeeEntity>(
      key: ValueKey('employees_${employees.length}_${employees.isNotEmpty ? employees.first.id : 0}'),
      columns: columns,
      data: employees,
      showCheckbox: false,
      config: BaseTableConfig(
        backgroundColor: AppColor.WHITE,
        headerColor: null,
        rowMinHeight: 56,
        rowMaxHeight: 200,
        borderRadius: 8,
        showBorder: false,
        fillWidth: false,
      ),
      onRowSelect: (employee, isSelected) {
        context.go('/employees/${employee.id}');
      },
    );
  }
}
