import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class NavbarItem extends StatelessWidget {
  const NavbarItem({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color foreground = isSelected ? AppColor.BLACK_0 : AppColor.GRAY_DARK;
    final Color background = isSelected
        ? AppColor.GRAY_F6F6F6
        : Colors.transparent;
    final isRTL = context.locale.languageCode == 'ar';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Align(
          alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              color: foreground,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
