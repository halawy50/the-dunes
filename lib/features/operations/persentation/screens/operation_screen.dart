import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/features/operations/persentation/cubit/operation_cubit.dart';

class OperationScreen extends StatefulWidget {
  const OperationScreen({super.key});

  @override
  State<OperationScreen> createState() => _OperationScreenState();
}

class _OperationScreenState extends State<OperationScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = di<OperationCubit>();
        cubit.init();
        return cubit;
      },
      child: BlocListener<OperationCubit, OperationState>(
        listener: (context, state) {
          if (state is OperationSuccess) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: 'operations.success',
              type: SnackbarType.success,
            );
          } else if (state is OperationError) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: state.message,
              type: SnackbarType.error,
            );
          }
        },
        child: BlocBuilder<OperationCubit, OperationState>(
          builder: (context, state) {
            if (state is OperationLoading) {
              return Container(
                color: AppColor.GRAY_F6F6F6,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            }

            return Container(
              width: double.infinity,
              color: AppColor.GRAY_F6F6F6,
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Text(
                  'operations.title'.tr(),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

