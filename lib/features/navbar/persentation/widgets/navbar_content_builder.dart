import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/app_router/app_router.dart';
import 'package:the_dunes/core/data/datasources/token_storage.dart';
import 'package:the_dunes/features/navbar/persentation/cubit/navbar_cubit.dart';
import 'package:the_dunes/features/navbar/persentation/widgets/app_layout.dart';
import 'package:the_dunes/features/navbar/persentation/widgets/navbar_navigation_handler.dart';
import 'package:the_dunes/features/navbar/persentation/widgets/navbar_permissions_checker.dart';
import 'package:the_dunes/features/navbar/persentation/widgets/navbar_section_builder.dart';
import 'package:the_dunes/features/navbar/persentation/widgets/sidebar.dart';
import 'package:the_dunes/features/navbar/persentation/widgets/top_bar.dart';

class NavbarContentBuilder {
  static Widget buildContent({
    required BuildContext context,
    required NavbarSection initialSection,
    required List<NavbarSection> allowedSections,
    required StatefulNavigationShell? navigationShell,
  }) {
    return BlocBuilder<NavbarCubit, NavbarState>(
      builder: (context, state) {
        final selectedSection = state.selectedSection;
        final requestedSection = initialSection;
        
        final validSection = NavbarPermissionsChecker.getValidSection(
          requestedSection: requestedSection,
          selectedSection: selectedSection,
          allowedSections: allowedSections,
        );

        NavbarPermissionsChecker.checkAndShowPermissionError(
          context,
          requestedSection,
          validSection,
          allowedSections,
        );

        if (state.selectedSection != validSection) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<NavbarCubit>().selectSection(validSection);
          });
        }

        return AppLayout(
          sidebar: Sidebar(
            sections: allowedSections,
            selectedSection: validSection,
            onSectionSelected: (section) {
              NavbarNavigationHandler.handleSectionSelection(
                context: context,
                section: section,
                navigationShell: navigationShell,
              );
            },
          ),
          topBar: TopBar(
            titleKey: validSection.translationKey,
            subtitleKey: validSection.subtitleKey,
            onLogout: () async {
              await TokenStorage.deleteToken();
              if (context.mounted) {
                context.go(AppRouter.login);
              }
            },
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child: KeyedSubtree(
              key: ValueKey(validSection),
              child: NavbarSectionBuilder.buildSectionPage(validSection),
            ),
          ),
        );
      },
    );
  }
}

