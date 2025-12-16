import 'dart:typed_data';
import 'package:the_dunes/core/network/api_client.dart';
import 'package:the_dunes/core/network/api_constants.dart';
import 'package:the_dunes/core/network/api_exception.dart';
import 'package:the_dunes/features/booking/data/models/document_analysis_response_model.dart';

class DocumentAnalysisRemoteDataSource {
  final ApiClient apiClient;

  DocumentAnalysisRemoteDataSource(this.apiClient);

  Future<DocumentAnalysisResponseModel> analyzeDocuments(
    Map<String, Uint8List> files,
  ) async {
    try {
      final response = await apiClient.postMultipart(
        ApiConstants.bookingsAnalyzeDocumentsEndpoint,
        {},
        files,
      );
      return DocumentAnalysisResponseModel.fromJson(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }
}

