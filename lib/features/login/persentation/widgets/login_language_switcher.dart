import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class LoginLanguageSwitcher extends StatefulWidget {
  const LoginLanguageSwitcher({super.key});

  @override
  State<LoginLanguageSwitcher> createState() => _LoginLanguageSwitcherState();
}

class _LoginLanguageSwitcherState extends State<LoginLanguageSwitcher> {
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
            if (mounted) {
              setState(() {});
            }
          },
          items: [
            DropdownMenuItem(
              value: 'en',
              child: const Text(
                'EN',
                style: TextStyle(
                  color: AppColor.WHITE,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            DropdownMenuItem(
              value: 'ar',
              child: const Text(
                'ع',
                style: TextStyle(
                  color: AppColor.WHITE,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
