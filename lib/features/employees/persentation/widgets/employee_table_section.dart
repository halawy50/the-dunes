import 'package:flutter/material.dart';
import 'package:the_dunes/features/employees/domain/entities/employee_entity.dart';
import 'package:the_dunes/features/employees/persentation/cubit/employee_cubit.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_table_widget.dart';

class EmployeeTableSection extends StatelessWidget {
  const EmployeeTableSection({
    super.key,
    required this.filteredEmployees,
    required this.state,
  });

  final List<EmployeeEntity> filteredEmployees;
  final EmployeeState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state is EmployeeLoading && state is! EmployeeLoaded)
          Container(
            height: 400,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          )
        else
          EmployeeTableWidget(
            employees: filteredEmployees,
          ),
      ],
    );
  }
}

