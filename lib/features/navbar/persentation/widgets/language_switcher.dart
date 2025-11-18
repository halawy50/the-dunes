import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/network/api_language_helper.dart';
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
            width: 18,
            height: 18,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 13),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentCode = context.locale.languageCode;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentCode,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: AppColor.BLACK_0,
          ),
          style: const TextStyle(fontSize: 13),
          onChanged: (value) async {
            if (value == null || value == currentCode) return;
            await context.setLocale(Locale(value));
            ApiLanguageHelper.updateApiLanguage(value);
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
            DropdownMenuItem(
              value: 'ru',
              child: _buildLanguageItem('ru', 'RU', AppImages.RUSSIAN_FLAG),
            ),
            DropdownMenuItem(
              value: 'hi',
              child: _buildLanguageItem('hi', 'HI', AppImages.INDIA_FLAG),
            ),
            DropdownMenuItem(
              value: 'de',
              child: _buildLanguageItem('de', 'DE', AppImages.GERMAN_FLAG),
            ),
            DropdownMenuItem(
              value: 'es',
              child: _buildLanguageItem('es', 'ES', AppImages.ISPANYA_FLAG),
            ),
          ],
        ),
      ),
    );
  }
}
