import 'dart:html' as html;

// Web implementation
class FileDownloadHelper {
  static Future<void> downloadFile(String url) async {
    html.window.open(url, '_blank');
  }
}

