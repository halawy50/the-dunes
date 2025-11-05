import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/features/overview/persentation/cubit/overview_cubit.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = sl<OverviewCubit>();
        cubit.init();
        return cubit;
      },
      child: BlocListener<OverviewCubit, OverviewState>(
        listener: (context, state) {
          if (state is OverviewSuccess) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: 'overview.success',
              type: SnackbarType.success,
            );
          } else if (state is OverviewError) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: state.message,
              type: SnackbarType.error,
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('overview.title'.tr()),
            backgroundColor: AppColor.BLACK_0,
          ),
          body: BlocBuilder<OverviewCubit, OverviewState>(
            builder: (context, state) {
              if (state is OverviewLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return const Center(
                child: Text('Overview Screen'),
              );
            },
          ),
        ),
      ),
    );
  }
}
