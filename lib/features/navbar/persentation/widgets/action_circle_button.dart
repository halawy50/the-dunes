import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class ActionCircleButton extends StatelessWidget {
  const ActionCircleButton({
    super.key,
    required this.asset,
    required this.onTap,
  });

  final String asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          asset,
          width: 16,
          height: 16,
          colorFilter: const ColorFilter.mode(
            AppColor.BLACK_0,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
