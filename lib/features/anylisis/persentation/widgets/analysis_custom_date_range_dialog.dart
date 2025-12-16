import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/features/anylisis/persentation/cubit/analysis_cubit.dart';

class AnalysisCustomDateRangeDialog {
  static Future<void> show(
    BuildContext context,
  ) async {
    final startDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (startDate != null) {
      final endDate = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: startDate,
        lastDate: DateTime(2100),
      );
      if (endDate != null) {
        final startTimestamp = DateTime(startDate.year, startDate.month, startDate.day)
            .millisecondsSinceEpoch ~/ 1000;
        final endTimestamp = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59)
            .millisecondsSinceEpoch ~/ 1000;
        context.read<AnalysisCubit>().loadAnalysisData(
          startDate: startTimestamp,
          endDate: endTimestamp,
        );
      }
    }
  }
}

