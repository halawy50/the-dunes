import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/data/datasources/token_storage.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColor.BLACK_0,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitleKey.tr(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.GRAY_DARK,
                  ),
                ),
              ],
            ),
          ),
          const LanguageSwitcher(),
          const SizedBox(width: 16),
          ActionCircleButton(
            asset: 'assets/icons/notification.svg',
            onTap: () {},
          ),
          const SizedBox(width: 16),
          FutureBuilder(
            future: TokenStorage.getUserData(),
            builder: (context, snapshot) {
              final userData = snapshot.data;
              final name = userData?['name'] as String? ?? 'common.user'.tr();
              final initials = name
                  .split(' ')
                  .take(2)
                  .map((word) => word.isNotEmpty ? word[0] : '')
                  .join()
                  .toUpperCase();
              
              return UserChip(
                name: name,
                initials: initials,
                onLogout: onLogout,
              );
            },
          ),
        ],
      ),
    );
  }
}
