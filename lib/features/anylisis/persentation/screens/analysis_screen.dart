import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/features/anylisis/persentation/cubit/analysis_cubit.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = sl<AnalysisCubit>();
        cubit.init();
        return cubit;
      },
      child: BlocListener<AnalysisCubit, AnalysisState>(
        listener: (context, state) {
          if (state is AnalysisSuccess) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: 'analysis.success',
              type: SnackbarType.success,
            );
          } else if (state is AnalysisError) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: state.message,
              type: SnackbarType.error,
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('analysis.title'.tr()),
            backgroundColor: AppColor.BLACK_0,
          ),
          body: BlocBuilder<AnalysisCubit, AnalysisState>(
            builder: (context, state) {
              if (state is AnalysisLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return const Center(
                child: Text('Analysis Screen'),
              );
            },
          ),
        ),
      ),
    );
  }
}
