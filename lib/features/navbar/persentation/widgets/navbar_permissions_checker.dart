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
    // If requested section is allowed, use it
    if (allowedSections.contains(requestedSection)) {
      return requestedSection;
    }
    // If selected section is allowed, use it
    if (allowedSections.contains(selectedSection)) {
      return selectedSection;
    }
    // Otherwise, redirect to first allowed section (but not employees if user doesn't have permission)
    // Prefer receiptVoucher, bookings, or other sections over employees
    final preferredSections = [
      NavbarSection.receiptVoucher,
      NavbarSection.bookings,
      NavbarSection.pickupTime,
      NavbarSection.services,
      NavbarSection.hotels,
      NavbarSection.camp,
    ];
    
    // Try to find a preferred section first
    for (final section in preferredSections) {
      if (allowedSections.contains(section)) {
        return section;
      }
    }
    
    // If no preferred section found, return first allowed (which might be employees)
    return allowedSections.first;
  }

  static void checkAndShowPermissionError(
    BuildContext context,
    NavbarSection requestedSection,
    NavbarSection validSection,
    List<NavbarSection> allowedSections,
  ) {
    // Only show error if requested section is not allowed AND valid section is different
    // But don't show error if valid section is the same as requested (user has permission)
    if (!allowedSections.contains(requestedSection) && 
        requestedSection != validSection &&
        allowedSections.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          AppSnackbar.showTranslated(
            context: context,
            translationKey: 'errors.no_page_permission',
            type: SnackbarType.error,
          );
        }
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

 