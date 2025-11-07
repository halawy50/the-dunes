import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/navbar/persentation/widgets/action_circle_button.dart';
import 'package:the_dunes/features/navbar/persentation/widgets/language_switcher.dart';
import 'package:the_dunes/features/navbar/persentation/widgets/user_chip.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.titleKey,
    required this.subtitleKey,
    required this.onLogout,
  });

  final String titleKey;
  final String subtitleKey;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: AppColor.WHITE,
        boxShadow: [
          BoxShadow(
            color: Color(0x14323232),
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleKey.tr(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColor.BLACK_0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitleKey.tr(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColor.GRAY_DARK,
                  ),
                ),
              ],
            ),
          ),
          const LanguageSwitcher(),
          const SizedBox(width: 24),
          ActionCircleButton(
            asset: 'assets/icons/notification.svg',
            onTap: () {},
          ),
          const SizedBox(width: 20),
          UserChip(name: 'Mohamed Farouk', initials: 'MF', onLogout: onLogout),
        ],
      ),
    );
  }
}
