import 'dart:io';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:path_provider/path_provider.dart';

class FileUtils {
  static Future<List<String>> splitTextToFiles(String text, String baseFileName) async {
    if (kDebugMode) {
      print('[FileUtils] splitTextToFiles called');
      print('[FileUtils] Base file name: $baseFileName');
      print('[FileUtils] Text length: ${text.length} characters');
    }

    final lines = text.split('\n');
    if (kDebugMode) print('[FileUtils] Total lines: ${lines.length}');

    if (lines.length <= 150) {
      // Text is within limit, save to single file
      if (kDebugMode) print('[FileUtils] Text within limit, saving to single file...');
      
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$baseFileName.txt');
      
      if (kDebugMode) print('[FileUtils] File path: ${file.path}');
      
      await file.writeAsString(text);
      
      if (kDebugMode) {
        print('[FileUtils] ✅ File created successfully');
        final fileSize = await file.length();
        print('[FileUtils] File size: $fileSize bytes');
      }
      
      return [file.path];
    }

    // Split into multiple files
    if (kDebugMode) print('[FileUtils] Text exceeds limit, splitting into multiple files...');
    
    final directory = await getApplicationDocumentsDirectory();
    final List<String> filePaths = [];
    final int fileCount = (lines.length / 150).ceil();

    if (kDebugMode) {
      print('[FileUtils] Will create $fileCount file(s)');
      print('[FileUtils] Directory: ${directory.path}');
    }

    for (int i = 0; i < fileCount; i++) {
      final start = i * 150;
      final end = (start + 150 < lines.length) ? start + 150 : lines.length;
      final fileLines = lines.sublist(start, end);
      final fileName = i == 0 
          ? '$baseFileName.txt' 
          : '${baseFileName}_part${i + 1}.txt';
      final file = File('${directory.path}/$fileName');
      
      if (kDebugMode) {
        print('[FileUtils] Creating file ${i + 1}/$fileCount: $fileName');
        print('[FileUtils]   Lines ${start + 1} to $end (${fileLines.length} lines)');
      }
      
      await file.writeAsString(fileLines.join('\n'));
      filePaths.add(file.path);
      
      if (kDebugMode) {
        final fileSize = await file.length();
        print('[FileUtils]   ✅ File created: ${fileSize} bytes');
      }
    }

    if (kDebugMode) {
      print('[FileUtils] ✅ All files created successfully');
      print('[FileUtils] Total files: ${filePaths.length}');
    }

    return filePaths;
  }
}
