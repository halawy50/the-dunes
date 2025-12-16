import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/employees/persentation/cubit/employee_detail_cubit.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_detail_content.dart';

class EmployeeDetailScreen extends StatelessWidget {
  final int employeeId;

  const EmployeeDetailScreen({
    super.key,
    required this.employeeId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = di<EmployeeDetailCubit>();
        cubit.loadEmployeeDetail(employeeId);
        return cubit;
      },
      child: BlocListener<EmployeeDetailCubit, EmployeeDetailState>(
        listener: (context, state) {
          if (state is EmployeeDetailError) {
            final message = state.message;
            if (message.contains('ApiException:')) {
              final errorMessage = message.replaceAll('ApiException: ', '');
              AppSnackbar.show(
                context: context,
                message: errorMessage,
                type: SnackbarType.error,
              );
            } else {
              AppSnackbar.show(
                context: context,
                message: message,
                type: SnackbarType.error,
              );
            }
          }
        },
        child: Scaffold(
          backgroundColor: AppColor.GRAY_F6F6F6,
          body: const EmployeeDetailContent(),
        ),
      ),
    );
  }
}

