import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class UserChip extends StatelessWidget {
  const UserChip({
    super.key,
    required this.name,
    required this.initials,
    required this.onLogout,
  });

  final String name;
  final String initials;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'logout') onLogout();
      },
      offset: const Offset(0, 40),
      position: PopupMenuPosition.under,
      color: AppColor.GRAY_F6F6F6,
      itemBuilder: (context) => [
        PopupMenuItem(value: 'logout', child: Text('common.logout'.tr())),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(999)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: AppColor.GRAY_D8D8D8,
              child: Text(
                initials,
                style: const TextStyle(
                  color: AppColor.BLACK_0,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              name,
              style: const TextStyle(
                color: AppColor.BLACK_0,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 3),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: AppColor.BLACK_0,
            ),
          ],
        ),
      ),
    );
  }
}
