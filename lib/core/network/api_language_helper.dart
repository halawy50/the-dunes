import 'package:the_dunes/core/dependency_injection/injection_container.dart'
    as di;
import 'package:the_dunes/core/network/api_client.dart';

class ApiLanguageHelper {
  static void updateApiLanguage(String languageCode) {
    final apiClient = di.di<ApiClient>();
    apiClient.setLanguage(languageCode);
  }

  static void initializeApiLanguage() {
    final apiClient = di.di<ApiClient>();
    apiClient.setLanguage('en');
  }
}

