import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

enum SnackbarType {
  success,
  error,
  warning,
  info,
}

class AppSnackbar {
  static void show({
    required BuildContext context,
    required String message,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    if (kDebugMode) {
      print('[AppSnackbar] Showing snackbar');
      print('[AppSnackbar] Type: $type');
      print('[AppSnackbar] Message: $message');
      print('[AppSnackbar] Duration: ${duration.inSeconds}s');
    }

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    // Get color and icon based on type
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (type) {
      case SnackbarType.success:
        backgroundColor = Colors.green;
        textColor = AppColor.WHITE;
        icon = Icons.check_circle;
        break;
      case SnackbarType.error:
        backgroundColor = AppColor.RED;
        textColor = AppColor.WHITE;
        icon = Icons.error;
        break;
      case SnackbarType.warning:
        backgroundColor = Colors.orange;
        textColor = AppColor.WHITE;
        icon = Icons.warning;
        break;
      case SnackbarType.info:
        backgroundColor = Colors.blue;
        textColor = AppColor.WHITE;
        icon = Icons.info;
        break;
    }

    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: textColor, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.only(
          top: topPadding + 8,
          left: 16,
          right: 16,
          bottom: 0,
        ),
        action: actionLabel != null && onActionPressed != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: textColor,
                onPressed: onActionPressed,
              )
            : null,
      ),
    );
  }

  // Convenience methods
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      type: SnackbarType.success,
      duration: duration,
    );
  }

  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      type: SnackbarType.error,
      duration: duration,
    );
  }

  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      type: SnackbarType.warning,
      duration: duration,
    );
  }

  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      type: SnackbarType.info,
      duration: duration,
    );
  }

  // Method with translation key
  static void showTranslated({
    required BuildContext context,
    required String translationKey,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 3),
    Map<String, String>? namedArgs,
    String? actionLabelKey,
    VoidCallback? onActionPressed,
  }) {
    final message = namedArgs != null
        ? translationKey.tr(namedArgs: namedArgs)
        : translationKey.tr();

    final actionLabel = actionLabelKey?.tr();

    show(
      context: context,
      message: message,
      type: type,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }
}
