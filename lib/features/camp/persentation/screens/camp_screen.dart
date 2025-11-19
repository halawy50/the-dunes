import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/features/camp/persentation/cubit/camp_cubit.dart';

class CampScreen extends StatefulWidget {
  const CampScreen({super.key});

  @override
  State<CampScreen> createState() => _CampScreenState();
}

class _CampScreenState extends State<CampScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = di<CampCubit>();
        cubit.init();
        return cubit;
      },
      child: BlocListener<CampCubit, CampState>(
        listener: (context, state) {
          if (state is CampSuccess) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: 'camp.success',
              type: SnackbarType.success,
            );
          } else if (state is CampError) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: state.message,
              type: SnackbarType.error,
            );
          }
        },
        child: BlocBuilder<CampCubit, CampState>(
          builder: (context, state) {
            if (state is CampLoading) {
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
                  'camp.title'.tr(),
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

