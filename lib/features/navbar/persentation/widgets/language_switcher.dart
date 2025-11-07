import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/utils/constants/assets/images.dart';

class LanguageSwitcher extends StatefulWidget {
  const LanguageSwitcher({super.key});

  @override
  State<LanguageSwitcher> createState() => _LanguageSwitcherState();
}

class _LanguageSwitcherState extends State<LanguageSwitcher> {
  Widget _buildLanguageItem(String code, String label, String flagAsset) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipOval(
          child: Image.asset(
            flagAsset,
            width: 20,
            height: 20,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentCode = context.locale.languageCode;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentCode,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColor.BLACK_0,
          ),
          onChanged: (value) async {
            if (value == null || value == currentCode) return;
            await context.setLocale(Locale(value));
            if (mounted) {
              setState(() {});
            }
          },
          items: [
            DropdownMenuItem(
              value: 'en',
              child: _buildLanguageItem('en', 'EN', AppImages.AMERCA_FLAG),
            ),
            DropdownMenuItem(
              value: 'ar',
              child: _buildLanguageItem('ar', 'ع', AppImages.EMARATE_FLAG),
            ),
          ],
        ),
      ),
    );
  }
}
