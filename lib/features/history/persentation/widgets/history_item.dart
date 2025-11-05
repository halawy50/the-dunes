import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class HistoryItem extends StatelessWidget {
  final String title;
  final String? date;
  final String? status;
  final VoidCallback? onTap;

  const HistoryItem({
    super.key,
    required this.title,
    this.date,
    this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: AppColor.BLACK,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: date != null
            ? Text(
                date!,
                style: const TextStyle(
                  color: AppColor.GRAY_HULF,
                ),
              )
            : null,
        trailing: status != null
            ? Chip(
                label: Text(status!),
                backgroundColor: AppColor.YELLOW.withOpacity(0.2),
              )
            : const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
