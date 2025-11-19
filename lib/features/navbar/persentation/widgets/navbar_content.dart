import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/data/datasources/token_storage.dart';
import 'package:the_dunes/features/navbar/persentation/cubit/navbar_cubit.dart';
import 'package:the_dunes/features/navbar/persentation/widgets/navbar_content_builder.dart';
import 'package:the_dunes/features/navbar/persentation/widgets/navbar_permissions_checker.dart';

class NavbarContent extends StatelessWidget {
  const NavbarContent({
    super.key,
    required this.initialSection,
    this.navigationShell,
  });

  final NavbarSection initialSection;
  final StatefulNavigationShell? navigationShell;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: TokenStorage.getPermissions(),
      builder: (context, snapshot) {
        final permissions = snapshot.data;
        final allSections = NavbarSection.values;
        final allowedSections = NavbarPermissionsChecker.getAllowedSections(
          allSections,
          permissions,
        );

        if (allowedSections.isEmpty) {
          return NavbarPermissionsChecker.buildNoPermissionsWidget();
        }

        return NavbarContentBuilder.buildContent(
          context: context,
          initialSection: initialSection,
          allowedSections: allowedSections,
          navigationShell: navigationShell,
        );
      },
    );
  }
}

