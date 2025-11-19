import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/network/api_language_helper.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/utils/constants/assets/images.dart';

class LoginLanguageSwitcher extends StatefulWidget {
  const LoginLanguageSwitcher({super.key});

  @override
  State<LoginLanguageSwitcher> createState() => _LoginLanguageSwitcherState();
}

class _LoginLanguageSwitcherState extends State<LoginLanguageSwitcher> {
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
        Text(
          label,
          style: const TextStyle(
            color: AppColor.WHITE,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentCode = context.locale.languageCode;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.BLACK_0.withOpacity(0.7),
        borderRadius: BorderRadius.circular(24),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentCode,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColor.WHITE,
            size: 20,
          ),
          dropdownColor: AppColor.BLACK_0.withOpacity(0.9),
          style: const TextStyle(
            color: AppColor.WHITE,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
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
