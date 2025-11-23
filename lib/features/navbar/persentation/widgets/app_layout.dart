import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/navbar/persentation/cubit/navbar_cubit.dart';

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
      backgroundColor: AppColor.WHITE,
      body: SafeArea(
        child: SelectionArea(
          selectionControls: materialTextSelectionControls,
          child: Directionality(
            textDirection: isRTL ? ui.TextDirection.rtl : ui.TextDirection.ltr,
            child: BlocBuilder<NavbarCubit, NavbarState>(
              builder: (context, state) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: state.isSidebarVisible
                          ? sidebar
                          : const SizedBox.shrink(),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          topBar,
                          Flexible(
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
