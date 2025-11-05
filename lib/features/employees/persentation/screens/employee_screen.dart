import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/features/employees/persentation/cubit/employee_cubit.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = sl<EmployeeCubit>();
        cubit.init();
        return cubit;
      },
      child: BlocListener<EmployeeCubit, EmployeeState>(
        listener: (context, state) {
          if (state is EmployeeSuccess) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: 'employee.success',
              type: SnackbarType.success,
            );
          } else if (state is EmployeeError) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: state.message,
              type: SnackbarType.error,
            );
          }
        },
        child: BlocBuilder<EmployeeCubit, EmployeeState>(
          builder: (context, state) {
            if (state is EmployeeLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const Padding(
              padding: EdgeInsets.all(24.0),
              child: Center(
                child: Text('Employee Screen'),
              ),
            );
          },
        ),
      ),
    );
  }
}
