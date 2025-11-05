import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class AnalysisCard extends StatelessWidget {
  final String title;
  final String? value;
  final IconData? icon;
  final Color? color;

  const AnalysisCard({
    super.key,
    required this.title,
    this.value,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (icon != null)
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: (color ?? AppColor.YELLOW).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color ?? AppColor.YELLOW,
                ),
              ),
            if (icon != null) const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColor.GRAY_HULF,
                      fontSize: 14,
                    ),
                  ),
                  if (value != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      value!,
                      style: const TextStyle(
                        color: AppColor.BLACK,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
