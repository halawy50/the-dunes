import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/file_utils.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';

class InputTextSplitHandler {
  final BuildContext context;
  final TextEditingController textController;
  final Function(List<String>)? onFilesSplit;
  bool _isProcessingSplit = false;

  InputTextSplitHandler({
    required this.context,
    required this.textController,
    this.onFilesSplit,
  });

  bool get isProcessingSplit => _isProcessingSplit;

  Future<void> checkAndSplitText() async {
    if (_isProcessingSplit) {
      if (kDebugMode) {
        print('[InputText] ⏳ Text splitting already in progress, skipping...');
      }
      return;
    }

    final text = textController.text;
    final lines = text.split('\n');

    if (kDebugMode) {
      print('[InputText] Checking text for splitting...');
      print('[InputText] Total lines: ${lines.length}');
    }

    if (lines.length > 150) {
      if (kDebugMode) {
        print('[InputText] ✅ Text exceeds 150 lines, starting file split process...');
        print('[InputText] Lines count: ${lines.length}');
      }
      _isProcessingSplit = true;
      try {
        final fileName = 'input_text_${DateTime.now().millisecondsSinceEpoch}';
        if (kDebugMode) {
          print('[InputText] Creating files with base name: $fileName');
        }

        final filePaths = await FileUtils.splitTextToFiles(text, fileName);

        if (kDebugMode) {
          print('[InputText] ✅ Text split successfully');
          print('[InputText] Files created: ${filePaths.length}');
          for (var i = 0; i < filePaths.length; i++) {
            print('[InputText]   File ${i + 1}: ${filePaths[i]}');
          }
        }

        onFilesSplit?.call(filePaths);
        if (context.mounted) {
          AppSnackbar.showTranslated(
            context: context,
            translationKey: 'file.text_split_success',
            type: SnackbarType.success,
            namedArgs: {'count': filePaths.length.toString()},
            duration: Duration(seconds: 3),
          );
        }
      } catch (e) {
        if (kDebugMode) {
          print('[InputText] ❌ Error splitting text: $e');
          print('[InputText] Error type: ${e.runtimeType}');
        }
        if (context.mounted) {
          AppSnackbar.showTranslated(
            context: context,
            translationKey: 'file.text_split_error',
            type: SnackbarType.error,
            namedArgs: {'error': e.toString()},
            duration: Duration(seconds: 3),
          );
        }
      } finally {
        _isProcessingSplit = false;
        if (kDebugMode) {
          print('[InputText] File split process completed');
        }
      }
    } else {
      if (kDebugMode) {
        print('[InputText] ℹ️  Text within limit (${lines.length} <= 150), no split needed');
      }
    }
  }
}

