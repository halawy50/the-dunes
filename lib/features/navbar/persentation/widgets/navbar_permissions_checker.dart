import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/features/navbar/persentation/cubit/navbar_cubit.dart';

class NavbarPermissionsChecker {
  static List<NavbarSection> getAllowedSections(
    List<NavbarSection> allSections,
    dynamic permissions,
  ) {
    return allSections
        .where((section) => section.isAllowed(permissions))
        .toList();
  }

  static NavbarSection getValidSection({
    required NavbarSection requestedSection,
    required NavbarSection selectedSection,
    required List<NavbarSection> allowedSections,
  }) {
    if (allowedSections.contains(requestedSection)) {
      return requestedSection;
    }
    if (allowedSections.contains(selectedSection)) {
      return selectedSection;
    }
    return allowedSections.first;
  }

  static void checkAndShowPermissionError(
    BuildContext context,
    NavbarSection requestedSection,
    NavbarSection validSection,
    List<NavbarSection> allowedSections,
  ) {
    if (!allowedSections.contains(requestedSection) && 
        requestedSection != validSection) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppSnackbar.showTranslated(
          context: context,
          translationKey: 'errors.no_page_permission',
          type: SnackbarType.error,
        );
      });
    }
  }

  static Widget buildNoPermissionsWidget() {
    return Scaffold(
      body: Center(
        child: Text('common.no_permissions'.tr()),
      ),
    );
  }
}

