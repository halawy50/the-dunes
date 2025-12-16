import 'package:the_dunes/features/booking/data/models/analyzed_data_model.dart';
import 'package:the_dunes/features/booking/data/models/matched_data_model.dart';

class DocumentAnalysisResponseModel {
  final List<AnalyzedDataModel> analyzedData;
  final List<MatchedDataModel> matchedData;
  final int totalFiles;
  final int successfulFiles;
  final int failedFiles;
  final List<String> errors;

  DocumentAnalysisResponseModel({
    required this.analyzedData,
    required this.matchedData,
    required this.totalFiles,
    required this.successfulFiles,
    required this.failedFiles,
    required this.errors,
  });

  factory DocumentAnalysisResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return DocumentAnalysisResponseModel(
      analyzedData: (data['analyzedData'] as List<dynamic>?)
              ?.map((e) => AnalyzedDataModel.fromJson(
                    e as Map<String, dynamic>,
                  ))
              .toList() ??
          [],
      matchedData: (data['matchedData'] as List<dynamic>?)
              ?.map((e) => MatchedDataModel.fromJson(
                    e as Map<String, dynamic>,
                  ))
              .toList() ??
          [],
      totalFiles: data['totalFiles'] as int? ?? 0,
      successfulFiles: data['successfulFiles'] as int? ?? 0,
      failedFiles: data['failedFiles'] as int? ?? 0,
      errors: (data['errors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'analyzedData': analyzedData.map((e) => e.toJson()).toList(),
        'matchedData': matchedData.map((e) => e.toJson()).toList(),
        'totalFiles': totalFiles,
        'successfulFiles': successfulFiles,
        'failedFiles': failedFiles,
        'errors': errors,
      },
    };
  }
}

