import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class BaseTableConfig {
  final Color? backgroundColor;
  final Color? headerColor;
  final double? rowMinHeight;
  final double? rowMaxHeight;
  final double? borderRadius;
  final bool showBorder;

  const BaseTableConfig({
    this.backgroundColor,
    this.headerColor,
    this.rowMinHeight,
    this.rowMaxHeight,
    this.borderRadius,
    this.showBorder = false,
  });

  static const BaseTableConfig defaultConfig = BaseTableConfig(
    backgroundColor: AppColor.WHITE,
    headerColor: AppColor.GRAY_F6F6F6,
    rowMinHeight: 56,
    rowMaxHeight: 200,
    borderRadius: 8,
    showBorder: false,
  );

  static const BaseTableConfig editableConfig = BaseTableConfig(
    backgroundColor: AppColor.WHITE,
    headerColor: AppColor.GRAY_F6F6F6,
    rowMinHeight: 48,
    rowMaxHeight: 1000,
    borderRadius: 0,
    showBorder: true,
  );
}

