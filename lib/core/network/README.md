# Network Layer

This directory contains the network layer implementation for API communication.

## Structure

- `api_client.dart` - Main HTTP client for API requests
- `api_constants.dart` - API endpoints and constants
- `api_exception.dart` - Custom exception handling
- `api_language_helper.dart` - Helper for language synchronization

## Usage

### ApiClient

The `ApiClient` handles all HTTP requests and automatically includes:
- Authorization token (if set)
- Language header (Accept-Language)

```dart
final apiClient = di.di<ApiClient>();

// Set token after login
apiClient.setToken('your-token-here');

// Set language
apiClient.setLanguage('ar'); // or 'en'

// Make requests
final response = await apiClient.get('/api/endpoint');
final postResponse = await apiClient.post('/api/endpoint', {'key': 'value'});
```

### Language Synchronization

The `ApiLanguageHelper` automatically syncs the API language with the app language:

```dart
// Update language when user changes it
ApiLanguageHelper.updateApiLanguage('ar');

// Initialize on app start
ApiLanguageHelper.initializeApiLanguage();
```

## Error Handling

All API errors are thrown as `ApiException`:

```dart
try {
  final response = await apiClient.get('/api/endpoint');
} on ApiException catch (e) {
  print('Error: ${e.message} (${e.statusCode})');
}
```

