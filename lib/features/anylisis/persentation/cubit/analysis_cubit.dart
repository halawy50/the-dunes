import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'analysis_state.dart';

class AnalysisCubit extends Cubit<AnalysisState> {
  AnalysisCubit() : super(AnalysisInitial());

  // TODO: Add your use cases here
  // final AnalysisUseCase analysisUseCase;

  void init() {
    if (kDebugMode) print('[AnalysisCubit] Initialized');
    // TODO: Implement initialization logic
  }

  void reset() {
    if (kDebugMode) print('[AnalysisCubit] State reset');
    emit(AnalysisInitial());
  }
}
