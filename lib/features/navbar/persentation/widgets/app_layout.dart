import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({
    super.key,
    required this.sidebar,
    required this.topBar,
    required this.body,
  });

  final Widget sidebar;
  final Widget topBar;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final isRTL = context.locale.languageCode == 'ar';
    return Scaffold(
      backgroundColor: AppColor.GRAY_WHITE,
      body: SafeArea(
        child: Directionality(
          textDirection: isRTL ? ui.TextDirection.rtl : ui.TextDirection.ltr,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              sidebar,
              Expanded(
                child: Column(
                  children: [
                    topBar,
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        color: AppColor.GRAY_WHITE,
                        child: body,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
