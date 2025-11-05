import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class EmployeeCard extends StatelessWidget {
  final String name;
  final String? position;
  final String? email;
  final VoidCallback? onTap;

  const EmployeeCard({
    super.key,
    required this.name,
    this.position,
    this.email,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColor.YELLOW,
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : 'E',
            style: const TextStyle(
              color: AppColor.BLACK,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            color: AppColor.BLACK,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (position != null)
              Text(
                position!,
                style: const TextStyle(
                  color: AppColor.GRAY_HULF,
                ),
              ),
            if (email != null)
              Text(
                email!,
                style: const TextStyle(
                  color: AppColor.GRAY_HULF,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
