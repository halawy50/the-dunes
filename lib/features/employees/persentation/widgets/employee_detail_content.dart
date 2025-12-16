import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/features/employees/persentation/cubit/employee_detail_cubit.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_detail_header.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_detail_info.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_detail_tabs.dart';

class EmployeeDetailContent extends StatefulWidget {
  const EmployeeDetailContent({super.key});

  @override
  State<EmployeeDetailContent> createState() => _EmployeeDetailContentState();
}

class _EmployeeDetailContentState extends State<EmployeeDetailContent> {
  EmployeeDetailLoaded? _lastLoadedState;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeDetailCubit, EmployeeDetailState>(
      builder: (context, state) {
        if (state is EmployeeDetailLoading) {
          if (_lastLoadedState != null) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  EmployeeDetailHeader(employee: _lastLoadedState!.employee),
                  EmployeeDetailInfo(employee: _lastLoadedState!.employee),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: EmployeeDetailTabs(
                      employee: _lastLoadedState!.employee,
                      commissions: _lastLoadedState!.commissions,
                      salaries: _lastLoadedState!.salaries,
                      totalPendingCommissions: _lastLoadedState!.totalPendingCommissions ?? 0.0,
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        }

        if (state is EmployeeDetailError) {
          if (_lastLoadedState != null) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  EmployeeDetailHeader(employee: _lastLoadedState!.employee),
                  EmployeeDetailInfo(employee: _lastLoadedState!.employee),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: EmployeeDetailTabs(
                      employee: _lastLoadedState!.employee,
                      commissions: _lastLoadedState!.commissions,
                      salaries: _lastLoadedState!.salaries,
                      totalPendingCommissions: _lastLoadedState!.totalPendingCommissions ?? 0.0,
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        }

        if (state is EmployeeDetailLoaded) {
          _lastLoadedState = state;
          return SingleChildScrollView(
            child: Column(
              children: [
                EmployeeDetailHeader(employee: state.employee),
                EmployeeDetailInfo(employee: state.employee),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: EmployeeDetailTabs(
                    employee: state.employee,
                    commissions: state.commissions,
                    salaries: state.salaries,
                    totalPendingCommissions: state.totalPendingCommissions ?? 0.0,
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
