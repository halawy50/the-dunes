import 'dart:html' as html;
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class DocumentAnalysisUploadArea extends StatefulWidget {
  final void Function(Map<String, Uint8List>) onFilesSelected;

  const DocumentAnalysisUploadArea({
    super.key,
    required this.onFilesSelected,
  });

  @override
  State<DocumentAnalysisUploadArea> createState() =>
      _DocumentAnalysisUploadAreaState();
}

class _DocumentAnalysisUploadAreaState
    extends State<DocumentAnalysisUploadArea> {
  bool _isDragging = false;
  html.Element? _dropZone;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _setupDragAndDrop();
      });
    }
  }

  void _setupDragAndDrop() {
    if (!kIsWeb) return;

    final context = this.context;
    if (context.mounted) {
      final renderObject = context.findRenderObject();
      if (renderObject != null) {
        final htmlElement = renderObject as html.Element;
        _dropZone = htmlElement;

        _dropZone!.onDragOver.listen((e) {
          e.preventDefault();
          setState(() => _isDragging = true);
        });

        _dropZone!.onDragLeave.listen((e) {
          setState(() => _isDragging = false);
        });

        _dropZone!.onDrop.listen((e) {
          e.preventDefault();
          setState(() => _isDragging = false);

          final dataTransfer = e.dataTransfer;
          final files = dataTransfer.files;
          if (files != null && files.length > 0) {
            _handleFileListFromDrop(files);
          }
        });
      }
    }
  }

  Future<void> _handleFileListFromDrop(dynamic files) async {
    final selectedFiles = <String, Uint8List>{};

    if (files is html.FileList) {
      for (var i = 0; i < files.length; i++) {
        final file = files[i];
        await _processFile(file, selectedFiles);
      }
    } else if (files is List<html.File>) {
      for (final file in files) {
        await _processFile(file, selectedFiles);
      }
    }

    if (selectedFiles.isNotEmpty) {
      widget.onFilesSelected(selectedFiles);
    }
  }

  Future<void> _handleFileList(List<html.File> files) async {
    final selectedFiles = <String, Uint8List>{};

    for (final file in files) {
      await _processFile(file, selectedFiles);
    }

    if (selectedFiles.isNotEmpty) {
      widget.onFilesSelected(selectedFiles);
    }
  }

  Future<void> _processFile(html.File file, Map<String, Uint8List> selectedFiles) async {
    final allowedExtensions = [
      'pdf',
      'xlsx',
      'xls',
      'jpg',
      'jpeg',
      'png',
      'gif',
      'webp'
    ];
    final extension = file.name.split('.').last.toLowerCase();
    if (allowedExtensions.contains(extension)) {
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      await reader.onLoad.first;
      final bytes = reader.result as Uint8List;
      selectedFiles[file.name] = bytes;
    }
  }

  Future<void> _pickFiles() async {
    final input = html.FileUploadInputElement()
      ..accept = '.pdf,.xlsx,.xls,.jpg,.jpeg,.png,.gif,.webp'
      ..multiple = true;
    input.click();

    input.onChange.listen((e) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        _handleFileList(files);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickFiles,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: _isDragging
              ? AppColor.YELLOW.withOpacity(0.1)
              : AppColor.WHITE,
          border: Border.all(
            color: _isDragging ? AppColor.YELLOW : AppColor.GRAY_HULF,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              size: 64,
              color: _isDragging ? AppColor.YELLOW : AppColor.GRAY_HULF,
            ),
            const SizedBox(height: 16),
            Text(
              'booking.drag_drop_files'.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'booking.supported_formats'.tr(),
              style: const TextStyle(
                fontSize: 14,
                color: AppColor.GRAY_HULF,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
