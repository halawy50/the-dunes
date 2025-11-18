import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/utils/url_helper.dart';
import 'package:the_dunes/features/navbar/persentation/cubit/navbar_cubit.dart';

class NavbarNavigationHandler {
  static int? getBranchIndex(NavbarSection section) {
    switch (section) {
      case NavbarSection.analysis:
        return 0;
      case NavbarSection.bookings:
        return 1;
      case NavbarSection.pickupTime:
        return 2;
      case NavbarSection.receiptVoucher:
        return 3;
      case NavbarSection.employees:
        return 4;
      case NavbarSection.services:
        return 5;
      case NavbarSection.hotels:
        return 6;
      case NavbarSection.operations:
        return 7;
      case NavbarSection.camp:
        return 8;
      case NavbarSection.history:
        return 9;
      case NavbarSection.settings:
        return 10;
    }
  }

  static void handleSectionSelection({
    required BuildContext context,
    required NavbarSection section,
    required StatefulNavigationShell? navigationShell,
  }) {
    context.read<NavbarCubit>().selectSection(section);
    
    if (navigationShell != null) {
      final branchIndex = getBranchIndex(section);
      if (branchIndex != null) {
        navigationShell.goBranch(branchIndex);
      }
    } else if (kIsWeb) {
      UrlHelper.updateUrl(section.route);
    } else {
      context.go(section.route);
    }
  }
}

