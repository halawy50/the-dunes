import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/features/employees/domain/entities/commission_entity.dart';
import 'package:the_dunes/features/employees/domain/entities/employee_entity.dart';
import 'package:the_dunes/features/employees/domain/entities/salary_entity.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_commission_tab.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_salary_tab.dart';

class EmployeeDetailTabs extends StatefulWidget {
  final EmployeeEntity employee;
  final List<CommissionEntity> commissions;
  final List<SalaryEntity> salaries;
  final double totalPendingCommissions;

  const EmployeeDetailTabs({
    super.key,
    required this.employee,
    required this.commissions,
    required this.salaries,
    required this.totalPendingCommissions,
  });

  @override
  State<EmployeeDetailTabs> createState() => _EmployeeDetailTabsState();
}

class _EmployeeDetailTabsState extends State<EmployeeDetailTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'employees.commetion'.tr()),
            Tab(text: 'employees.sallery'.tr()),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              EmployeeCommissionTab(
                employee: widget.employee,
                commissions: widget.commissions,
                totalPendingCommissions: widget.totalPendingCommissions,
              ),
              EmployeeSalaryTab(
                employee: widget.employee,
                salaries: widget.salaries,
              ),
            ],
          ),
        ),
      ],
    );
  }
}



