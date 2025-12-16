import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/employees/persentation/cubit/new_employee_cubit.dart';
import 'package:the_dunes/features/employees/persentation/widgets/new_employee_content.dart';

class NewEmployeeScreen extends StatelessWidget {
  const NewEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<NewEmployeeCubit>(),
      child: Scaffold(
        backgroundColor: AppColor.GRAY_F6F6F6,
        body: const NewEmployeeContent(),
      ),
    );
  }
}



