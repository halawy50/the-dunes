import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/employees/domain/entities/commission_entity.dart';
import 'package:the_dunes/features/employees/domain/entities/employee_entity.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_commission_bulk_pay_dialog.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_commission_filter.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_commission_pay_dialog.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_commission_selection_bar.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_commission_statistics.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_commission_table.dart';

class EmployeeCommissionTab extends StatefulWidget {
  final EmployeeEntity employee;
  final List<CommissionEntity> commissions;
  final double totalPendingCommissions;

  const EmployeeCommissionTab({
    super.key,
    required this.employee,
    required this.commissions,
    required this.totalPendingCommissions,
  });

  @override
  State<EmployeeCommissionTab> createState() => _EmployeeCommissionTabState();
}

class _EmployeeCommissionTabState extends State<EmployeeCommissionTab> {
  final List<CommissionEntity> _selectedCommissions = [];
  CommissionFilterStatus _selectedFilter = CommissionFilterStatus.all;

  List<CommissionEntity> get _filteredCommissions {
    switch (_selectedFilter) {
      case CommissionFilterStatus.pending:
        return widget.commissions.where((c) => c.status == 'PENDING').toList();
      case CommissionFilterStatus.paid:
        return widget.commissions.where((c) => c.status == 'PAID').toList();
      case CommissionFilterStatus.all:
        return widget.commissions;
    }
  }

  @override
  Widget build(BuildContext context) {
    final paidCommissions = widget.commissions.where((c) => c.status == 'PAID').toList();
    final totalPaid = paidCommissions.fold<double>(0.0, (sum, c) => sum + c.amount);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: EmployeeCommissionStatistics(
              voucherCount: widget.commissions.length,
              pendingProfits: widget.totalPendingCommissions,
              profitsPaid: totalPaid,
            ),
          ),
          EmployeeCommissionFilter(
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
                _selectedCommissions.clear();
              });
            },
          ),
          EmployeeCommissionSelectionBar(
            selectedCommissions: _selectedCommissions,
            allCommissions: _filteredCommissions,
            onPaySelected: () {
              EmployeeCommissionBulkPayDialog.show(
                context,
                _selectedCommissions,
                () {
                  setState(() {
                    _selectedCommissions.clear();
                  });
                },
              );
            },
            onSelectAllPending: () {
              setState(() {
                final pendingCommissions = _filteredCommissions
                    .where((c) => c.status == 'PENDING')
                    .toList();
                _selectedCommissions.clear();
                _selectedCommissions.addAll(pendingCommissions);
              });
            },
          ),
          Container(
            width: double.infinity,
            color: AppColor.WHITE,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: EmployeeCommissionTable(
              commissions: _filteredCommissions,
              onPayCommission: (commissionId) {
                final commission = widget.commissions.firstWhere((c) => c.id == commissionId);
                EmployeeCommissionPayDialog.show(
                  context,
                  commission,
                  widget.employee,
                );
              },
              selectedCommissions: _selectedCommissions,
              onCommissionSelect: (commission, isSelected) {
                setState(() {
                  if (isSelected) {
                    if (!_selectedCommissions.contains(commission)) {
                      _selectedCommissions.add(commission);
                    }
                  } else {
                    _selectedCommissions.remove(commission);
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
