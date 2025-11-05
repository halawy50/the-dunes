# AppSnackbar Usage Guide

`AppSnackbar` is a general utility class for showing snackbars throughout the app with support for different types and translations.

## Import

```dart
import 'package:the_dunes/core/utils/app_snackbar.dart';
```

## Usage Examples

### 1. Simple Success Message
```dart
AppSnackbar.showSuccess(
  context,
  'Operation completed successfully!',
);
```

### 2. Error Message
```dart
AppSnackbar.showError(
  context,
  'Something went wrong!',
);
```

### 3. Warning Message
```dart
AppSnackbar.showWarning(
  context,
  'Please check your input',
);
```

### 4. Info Message
```dart
AppSnackbar.showInfo(
  context,
  'New update available',
);
```

### 5. With Translation Key
```dart
AppSnackbar.showTranslated(
  context: context,
  translationKey: 'login.fill_all_fields',
  type: SnackbarType.warning,
);
```

### 6. With Translation and Named Arguments
```dart
AppSnackbar.showTranslated(
  context: context,
  translationKey: 'file.text_split_success',
  type: SnackbarType.success,
  namedArgs: {'count': '3'},
);
```

### 7. Custom with Action Button
```dart
AppSnackbar.show(
  context: context,
  message: 'Message deleted',
  type: SnackbarType.success,
  actionLabel: 'Undo',
  onActionPressed: () {
    // Undo action
  },
);
```

### 8. Custom Duration
```dart
AppSnackbar.showSuccess(
  context,
  'Message saved',
  duration: Duration(seconds: 5),
);
```

## Snackbar Types

- `SnackbarType.success` - Green background with check icon
- `SnackbarType.error` - Red background with error icon
- `SnackbarType.warning` - Orange background with warning icon
- `SnackbarType.info` - Blue background with info icon
