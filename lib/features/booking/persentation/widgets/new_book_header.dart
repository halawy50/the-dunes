import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/booking/persentation/cubit/new_booking_cubit.dart';
import 'package:the_dunes/features/booking/persentation/widgets/new_book_header_actions.dart';

class NewBookHeader extends StatelessWidget {
  const NewBookHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<NewBookingCubit, NewBookingState>(
      listener: (context, state) {
        // Only show errors for saving operations, not for init errors
        if (state is NewBookingError) {
          // Check if this is a save error (state was NewBookingSaving before)
          // We'll show the error message
          final message = state.message;
          if (message.contains('booking.') || 
              message.contains('errors.')) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: message,
              type: SnackbarType.error,
            );
          } else {
            AppSnackbar.show(
              context: context,
              message: message,
              type: SnackbarType.error,
            );
          }
        } else if (state is NewBookingSaved) {
          AppSnackbar.showTranslated(
            context: context,
            translationKey: 'booking.saved_successfully',
            type: SnackbarType.success,
          );
          context.go('/booking');
        }
      },
      child: Container(
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
          const NewBookHeaderActions(),
        ],
      ),
    ),
    );
  }
}

