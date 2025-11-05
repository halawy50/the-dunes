import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class NotificationItem extends StatelessWidget {
  final String title;
  final String? message;
  final VoidCallback? onTap;

  const NotificationItem({
    super.key,
    required this.title,
    this.message,
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
        subtitle: message != null
            ? Text(
                message!,
                style: const TextStyle(
                  color: AppColor.GRAY_HULF,
                ),
              )
            : null,
        onTap: onTap,
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
