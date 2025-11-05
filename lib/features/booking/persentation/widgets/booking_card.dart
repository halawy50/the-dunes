import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class BookingCard extends StatelessWidget {
  final String bookingId;
  final String? hotelName;
  final String? checkInDate;
  final String? checkOutDate;
  final String? status;
  final VoidCallback? onTap;

  const BookingCard({
    super.key,
    required this.bookingId,
    this.hotelName,
    this.checkInDate,
    this.checkOutDate,
    this.status,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Booking #$bookingId',
                    style: const TextStyle(
                      color: AppColor.BLACK,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (status != null)
                    Chip(
                      label: Text(status!),
                      backgroundColor: AppColor.YELLOW.withOpacity(0.2),
                    ),
                ],
              ),
              if (hotelName != null) ...[
                const SizedBox(height: 8),
                Text(
                  hotelName!,
                  style: const TextStyle(
                    color: AppColor.GRAY_HULF,
                  ),
                ),
              ],
              if (checkInDate != null || checkOutDate != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (checkInDate != null)
                      Text(
                        'Check-in: $checkInDate',
                        style: const TextStyle(
                          color: AppColor.GRAY_HULF,
                          fontSize: 12,
                        ),
                      ),
                    if (checkInDate != null && checkOutDate != null)
                      const Text(' | ', style: TextStyle(color: AppColor.GRAY_HULF)),
                    if (checkOutDate != null)
                      Text(
                        'Check-out: $checkOutDate',
                        style: const TextStyle(
                          color: AppColor.GRAY_HULF,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
