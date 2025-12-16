import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/employees/persentation/cubit/new_employee_cubit.dart';

class NewEmployeeHeader extends StatelessWidget {
  const NewEmployeeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColor.WHITE,
        boxShadow: [
          BoxShadow(
            color: Color(0x14323232),
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'employees.new_employee'.tr(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildSaveButton(context),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return BlocBuilder<NewEmployeeCubit, NewEmployeeState>(
      builder: (context, state) {
        final isLoading = state is NewEmployeeLoading;
        return ElevatedButton(
          onPressed: isLoading ? null : () {
            context.read<NewEmployeeCubit>().createEmployee();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.YELLOW,
            foregroundColor: AppColor.WHITE,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColor.WHITE,
                  ),
                )
              : Text('common.save'.tr()),
        );
      },
    );
  }
}


