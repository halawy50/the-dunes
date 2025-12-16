import 'package:flutter/material.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_config.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_widget.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/employees/domain/entities/commission_entity.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_commission_table_columns.dart';

class EmployeeCommissionTable extends StatelessWidget {
  final List<CommissionEntity> commissions;
  final void Function(int) onPayCommission;
  final List<CommissionEntity> selectedCommissions;
  final void Function(CommissionEntity, bool) onCommissionSelect;

  const EmployeeCommissionTable({
    super.key,
    required this.commissions,
    required this.onPayCommission,
    required this.selectedCommissions,
    required this.onCommissionSelect,
  });

  @override
  Widget build(BuildContext context) {
    final columns = EmployeeCommissionTableColumns.buildColumns(onPayCommission);

    return BaseTableWidget<CommissionEntity>(
      key: ValueKey('commissions_${commissions.length}'),
      columns: columns,
      data: commissions,
      showCheckbox: true,
      selectedRows: selectedCommissions,
      onRowSelect: onCommissionSelect,
      config: BaseTableConfig(
        backgroundColor: AppColor.WHITE,
        headerColor: null,
        rowMinHeight: 56,
        rowMaxHeight: 200,
        borderRadius: 8,
        showBorder: false,
        fillWidth: true,
      ),
    );
  }
}



