import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/booking/persentation/cubit/new_booking_cubit.dart';
import 'package:the_dunes/features/booking/persentation/widgets/document_analysis_screen.dart';

class NewBookHeaderActions extends StatelessWidget {
  const NewBookHeaderActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedButton.icon(
          onPressed: () async {
            final newBookingCubit = context.read<NewBookingCubit>();
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DocumentAnalysisScreen(
                  onAddToNewBook: (bookingRows) {
                    newBookingCubit.addBookingRowsFromAnalysis(bookingRows);
                  },
                ),
                fullscreenDialog: true,
              ),
            );
          },
          icon: const Icon(Icons.upload_file),
          label: Text('booking.analyze_documents'.tr()),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(width: 12),
        BlocBuilder<NewBookingCubit, NewBookingState>(
          buildWhen: (previous, current) {
            return previous.runtimeType != current.runtimeType ||
                   current is NewBookingLoaded;
          },
          builder: (context, state) {
            final cubit = context.read<NewBookingCubit>();
            final validCount = cubit.getValidBookingsCount();
            final isLoading = state is NewBookingSaving;
            
            return ElevatedButton(
              onPressed: isLoading || validCount == 0
                  ? null
                  : () {
                      cubit.saveBookings();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: isLoading || validCount == 0
                    ? AppColor.GRAY_HULF
                    : AppColor.YELLOW,
                foregroundColor: AppColor.WHITE,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColor.WHITE),
                      ),
                    )
                  : Text(
                      validCount > 0
                          ? '${'common.save'.tr()} (${validCount})'
                          : 'common.save'.tr(),
                    ),
            );
          },
        ),
      ],
    );
  }
}

