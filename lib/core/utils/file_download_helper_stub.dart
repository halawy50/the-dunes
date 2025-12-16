// Stub implementation for non-web platforms
class FileDownloadHelper {
  static Future<void> downloadFile(String url) async {
    throw UnsupportedError('File download is only supported on web');
  }
}

