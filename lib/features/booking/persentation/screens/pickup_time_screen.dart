import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/features/booking/persentation/cubit/pickup_time_cubit.dart';

class PickupTimeScreen extends StatefulWidget {
  const PickupTimeScreen({super.key});

  @override
  State<PickupTimeScreen> createState() => _PickupTimeScreenState();
}

class _PickupTimeScreenState extends State<PickupTimeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = di<PickupTimeCubit>();
        cubit.init();
        return cubit;
      },
      child: BlocListener<PickupTimeCubit, PickupTimeState>(
        listener: (context, state) {
          if (state is PickupTimeSuccess) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: 'booking.pickup_time_success',
              type: SnackbarType.success,
            );
          } else if (state is PickupTimeError) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: state.message,
              type: SnackbarType.error,
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColor.GRAY_F6F6F6,
          body: BlocBuilder<PickupTimeCubit, PickupTimeState>(
            builder: (context, state) {
              if (state is PickupTimeLoading) {
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
                    'booking.pickup_time'.tr(),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
