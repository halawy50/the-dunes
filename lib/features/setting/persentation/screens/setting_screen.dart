import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/features/setting/persentation/cubit/setting_cubit.dart';
import 'package:the_dunes/features/setting/persentation/widgets/setting_content.dart';

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
        final cubit = di<SettingCubit>();
        cubit.init();
        return cubit;
      },
      child: BlocListener<SettingCubit, SettingState>(
        listenWhen: (previous, current) {
          return current is SettingError;
        },
        listener: (context, state) {
          if (state is SettingError) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: state.message,
              type: SnackbarType.error,
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColor.GRAY_F6F6F6,
          body: const SettingContent(),
        ),
      ),
    );
  }
}
