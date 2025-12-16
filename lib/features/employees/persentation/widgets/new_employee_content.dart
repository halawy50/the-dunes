import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/employees/persentation/cubit/new_employee_cubit.dart';
import 'package:the_dunes/features/employees/persentation/widgets/new_employee_header.dart';
import 'package:the_dunes/features/employees/persentation/widgets/new_employee_form.dart';

class NewEmployeeContent extends StatelessWidget {
  const NewEmployeeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<NewEmployeeCubit, NewEmployeeState>(
      listener: (context, state) {
        if (state is NewEmployeeSuccess) {
          if (context.mounted) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: state.message,
              type: SnackbarType.success,
            );
            context.go('/employees');
          }
        } else if (state is NewEmployeeError) {
          if (context.mounted) {
            AppSnackbar.show(
              context: context,
              message: state.message,
              type: SnackbarType.error,
            );
          }
        }
      },
      child: Column(
        children: [
          const NewEmployeeHeader(),
          Expanded(
            child: Container(
              color: AppColor.WHITE,
              child: const SingleChildScrollView(
                child: NewEmployeeForm(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

