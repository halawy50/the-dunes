import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/features/booking/persentation/cubit/document_analysis_cubit.dart';
import 'package:the_dunes/features/booking/persentation/widgets/document_analysis_file_list.dart';
import 'package:the_dunes/features/booking/persentation/widgets/document_analysis_upload_area.dart';

class DocumentAnalysisFileUpload extends StatefulWidget {
  const DocumentAnalysisFileUpload({super.key});

  @override
  State<DocumentAnalysisFileUpload> createState() =>
      _DocumentAnalysisFileUploadState();
}

class _DocumentAnalysisFileUploadState
    extends State<DocumentAnalysisFileUpload> {
  final Map<String, Uint8List> _selectedFiles = {};

  void _handleFilesSelected(Map<String, Uint8List> files) {
    setState(() {
      _selectedFiles.addAll(files);
    });
  }

  void _removeFile(String fileName) {
    setState(() => _selectedFiles.remove(fileName));
  }

  void _analyzeFiles() {
    if (_selectedFiles.isEmpty) return;
    context.read<DocumentAnalysisCubit>().analyzeDocuments(_selectedFiles);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentAnalysisCubit, DocumentAnalysisState>(
      builder: (context, state) {
        final isLoading = state is DocumentAnalysisLoading ||
            state is DocumentAnalysisCreating;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DocumentAnalysisUploadArea(onFilesSelected: _handleFilesSelected),
            if (_selectedFiles.isNotEmpty) ...[
              const SizedBox(height: 16),
              DocumentAnalysisFileList(
                files: _selectedFiles,
                onRemove: _removeFile,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isLoading ? null : _analyzeFiles,
                child: isLoading
                    ? const SizedBox(
                        height: 20,  
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text('booking.analyze'.tr()),
              ),
            ],
          ],
        );
      },
    );
  }
}

