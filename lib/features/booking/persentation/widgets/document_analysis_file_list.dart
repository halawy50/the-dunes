import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class DocumentAnalysisFileList extends StatelessWidget {
  final Map<String, Uint8List> files;
  final void Function(String) onRemove;

  const DocumentAnalysisFileList({
    super.key,
    required this.files,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty) return const SizedBox.shrink();

    return Column(
      children: files.keys.map((fileName) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColor.WHITE,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColor.GRAY_HULF),
          ),
          child: Row(
            children: [
              const Icon(Icons.insert_drive_file),
              const SizedBox(width: 12),
              Expanded(child: Text(fileName)),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => onRemove(fileName),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

