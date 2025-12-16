import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/features/employees/persentation/cubit/new_employee_cubit.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_details_form.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_permissions_grid.dart';

class NewEmployeeForm extends StatelessWidget {
  const NewEmployeeForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewEmployeeCubit, NewEmployeeState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const EmployeeDetailsForm(),
              const SizedBox(height: 32),
              Text(
                'employees.permissions'.tr() + ' *',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const EmployeePermissionsGrid(),
            ],
          ),
        );
      },
    );
  }
}


