import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/booking/persentation/cubit/new_booking_cubit.dart';

class NewBookHeader extends StatelessWidget {
  const NewBookHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColor.WHITE,
        boxShadow: [
          BoxShadow(
            color: Color(0x14323232),
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/booking'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'booking.new_book'.tr(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'booking.description'.tr(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColor.GRAY_DARK,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<NewBookingCubit>().saveBookings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.YELLOW,
              foregroundColor: AppColor.WHITE,
            ),
            child: Text('common.save'.tr()),
          ),
        ],
      ),
    );
  }
}

