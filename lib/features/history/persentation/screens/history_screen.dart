import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/features/history/persentation/cubit/history_cubit.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = sl<HistoryCubit>();
        cubit.init();
        return cubit;
      },
      child: BlocListener<HistoryCubit, HistoryState>(
        listener: (context, state) {
          if (state is HistorySuccess) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: 'history.success',
              type: SnackbarType.success,
            );
          } else if (state is HistoryError) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: state.message,
              type: SnackbarType.error,
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('history.title'.tr()),
            backgroundColor: AppColor.BLACK_0,
          ),
          body: BlocBuilder<HistoryCubit, HistoryState>(
            builder: (context, state) {
              if (state is HistoryLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return const Center(
                child: Text('History Screen'),
              );
            },
          ),
        ),
      ),
    );
  }
}
