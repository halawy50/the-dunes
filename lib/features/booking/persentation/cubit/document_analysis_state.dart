part of 'document_analysis_cubit.dart';

abstract class DocumentAnalysisState extends Equatable {
  const DocumentAnalysisState();

  @override
  List<Object?> get props => [];
}

class DocumentAnalysisInitial extends DocumentAnalysisState {}

class DocumentAnalysisLoading extends DocumentAnalysisState {}

class DocumentAnalysisLoaded extends DocumentAnalysisState {
  final DocumentAnalysisResponseModel response;

  const DocumentAnalysisLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

class DocumentAnalysisCreating extends DocumentAnalysisState {}

class DocumentAnalysisSuccess extends DocumentAnalysisState {
  final String message;
  final int createdCount;

  const DocumentAnalysisSuccess({
    required this.message,
    required this.createdCount,
  });

  @override
  List<Object?> get props => [message, createdCount];
}

class DocumentAnalysisError extends DocumentAnalysisState {
  final String message;

  const DocumentAnalysisError(this.message);

  @override
  List<Object?> get props => [message];
}

