import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class ServiceItem extends StatelessWidget {
  final String name;
  final String? description;
  final IconData? icon;
  final VoidCallback? onTap;

  const ServiceItem({
    super.key,
    required this.name,
    this.description,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: icon != null
            ? Icon(icon, color: AppColor.YELLOW)
            : const Icon(Icons.build, color: AppColor.YELLOW),
        title: Text(
          name,
          style: const TextStyle(
            color: AppColor.BLACK,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: description != null
            ? Text(
                description!,
                style: const TextStyle(
                  color: AppColor.GRAY_HULF,
                ),
              )
            : null,
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
