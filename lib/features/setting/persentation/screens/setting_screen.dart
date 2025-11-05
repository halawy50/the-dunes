import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/features/setting/persentation/cubit/setting_cubit.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = sl<SettingCubit>();
        cubit.init();
        return cubit;
      },
      child: BlocListener<SettingCubit, SettingState>(
        listener: (context, state) {
          if (state is SettingSuccess) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: 'setting.success',
              type: SnackbarType.success,
            );
          } else if (state is SettingError) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: state.message,
              type: SnackbarType.error,
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('setting.title'.tr()),
            backgroundColor: AppColor.BLACK_0,
          ),
          body: BlocBuilder<SettingCubit, SettingState>(
            builder: (context, state) {
              if (state is SettingLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return const Center(
                child: Text('Setting Screen'),
              );
            },
          ),
        ),
      ),
    );
  }
}
