import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/features/anylisis/persentation/cubit/analysis_cubit.dart';
import 'package:the_dunes/features/anylisis/persentation/widgets/analysis_content_builder.dart';

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
        final cubit = di<AnalysisCubit>();
        cubit.loadAnalysisData();
        return cubit;
      },
      child: BlocListener<AnalysisCubit, AnalysisState>(
        listener: (context, state) {
          if (state is AnalysisError) {
            AppSnackbar.show(
              context: context,
              message: state.message.replaceAll('ApiException: ', ''),
              type: SnackbarType.error,
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColor.WHITE,
          body: BlocBuilder<AnalysisCubit, AnalysisState>(
            builder: (context, state) {
              if (state is AnalysisLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is AnalysisLoaded) {
                return AnalysisContentBuilder(
                  dashboardSummary: state.dashboardSummary,
                  bookingsByAgency: state.bookingsByAgency,
                  employeesWithVouchers: state.employeesWithVouchers,
                );
              }

              if (state is AnalysisError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message.replaceAll('ApiException: ', '')),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AnalysisCubit>().loadAnalysisData();
                        },
                        child: Text('common.retry'.tr()),
                      ),
                    ],
                  ),
                );
              }

              return Center(
                child: Text('analysis.no_data'.tr()),
              );
            },
          ),
        ),
      ),
    );
  }
}
