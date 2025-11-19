import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/utils/constants/assets/images.dart';
import 'package:the_dunes/features/navbar/persentation/cubit/navbar_cubit.dart';
import 'package:the_dunes/features/navbar/persentation/widgets/navbar_item.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({
    super.key,
    required this.sections,
    required this.selectedSection,
    required this.onSectionSelected,
  });

  final List<NavbarSection> sections;
  final NavbarSection selectedSection;
  final ValueChanged<NavbarSection> onSectionSelected;

  @override
  Widget build(BuildContext context) {
    final hasSettings = sections.contains(NavbarSection.settings);
    final mainSections = sections
        .where((section) => section != NavbarSection.settings)
        .toList();

    return Container(
      width: 220,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(color: AppColor.WHITE),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AppImages.LOGO_BLACK, width: 40, height: 40),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Directionality(
                      textDirection: ui.TextDirection.ltr,
                      child: const Text(
                        'THE DUNES',
                        style: TextStyle(
                          color: AppColor.YELLOW,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Directionality(
                      textDirection: ui.TextDirection.ltr,
                      child: const Text(
                        'Travel & Tourism',
                        style: TextStyle(
                          color: AppColor.BLACK_0,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<NavbarCubit, NavbarState>(
                builder: (context, state) {
                  return IconButton(
                    icon: const Icon(
                      Icons.menu_open,
                      size: 20,
                      color: AppColor.BLACK_0,
                    ),
                    onPressed: () {
                      context.read<NavbarCubit>().toggleSidebar();
                    },
                    tooltip: 'common.hide_menu'.tr(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final section = mainSections[index];
                return NavbarItem(
                  title: section.translationKey.tr(),
                  isSelected: section == selectedSection,
                  onTap: () => onSectionSelected(section),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemCount: mainSections.length,
            ),
          ),
          if (hasSettings) ...[
            const SizedBox(height: 8),
            const Divider(height: 1, color: AppColor.GRAY_D8D8D8),
            const SizedBox(height: 8),
            NavbarItem(
              title: NavbarSection.settings.translationKey.tr(),
              isSelected: selectedSection == NavbarSection.settings,
              onTap: () => onSectionSelected(NavbarSection.settings),
            ),
          ],
        ],
      ),
    );
  }
}
