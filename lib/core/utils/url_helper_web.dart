import 'dart:html' as html;

// Web implementation
class UrlHelper {
  static void updateUrl(String path) {
    html.window.history.pushState(null, '', path);
  }
}

