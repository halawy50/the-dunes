import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
      case NavbarSection.agents:
        return 5;
      case NavbarSection.services:
        return 6;
      case NavbarSection.hotels:
        return 7;
      case NavbarSection.operations:
        return 8;
      case NavbarSection.camp:
        return 9;
      case NavbarSection.history:
        return 10;
      case NavbarSection.settings:
        return 11;
    }
  }

  static void handleSectionSelection({
    required BuildContext context,
    required NavbarSection section,
    required StatefulNavigationShell? navigationShell,
  }) {
    context.read<NavbarCubit>().selectSection(section);
    
    // Always navigate to the route to update the URL
    final route = section.route;
    if (navigationShell != null) {
      final branchIndex = getBranchIndex(section);
      if (branchIndex != null) {
        // Navigate to the route first to update URL, then switch branch
        context.go(route);
        // Use goBranch to switch the branch without losing state
        navigationShell.goBranch(branchIndex);
      } else {
        context.go(route);
      }
    } else {
      context.go(route);
    }
  }
}

