import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class HotelCard extends StatelessWidget {
  final String name;
  final String? location;
  final String? price;
  final VoidCallback? onTap;

  const HotelCard({
    super.key,
    required this.name,
    this.location,
    this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: AppColor.BLACK,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              if (location != null) ...[
                const SizedBox(height: 8),
                Text(
                  location!,
                  style: const TextStyle(
                    color: AppColor.GRAY_HULF,
                  ),
                ),
              ],
              if (price != null) ...[
                const SizedBox(height: 8),
                Text(
                  price!,
                  style: const TextStyle(
                    color: AppColor.YELLOW,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
