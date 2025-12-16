import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/booking/data/models/document_analysis_response_model.dart';
import 'package:the_dunes/features/booking/persentation/cubit/document_analysis_cubit.dart';
import 'package:the_dunes/features/booking/persentation/models/new_booking_row.dart';
import 'package:the_dunes/features/booking/persentation/widgets/matched_data_card.dart';

class DocumentAnalysisResults extends StatelessWidget {
  final DocumentAnalysisResponseModel response;
  final void Function(List<NewBookingRow>)? onAddToNewBook;

  const DocumentAnalysisResults({
    super.key,
    required this.response,
    this.onAddToNewBook,
  });

  void _createBookings(BuildContext context) {
    context.read<DocumentAnalysisCubit>().createBookingsFromMatchedData(
          response.matchedData,
        );
  }

  void _addToNewBook(BuildContext context) {
    if (onAddToNewBook == null) {
      AppSnackbar.showTranslated(
        context: context,
        translationKey: 'booking.no_valid_bookings',
        type: SnackbarType.error,
      );
      return;
    }

    final analysisCubit = context.read<DocumentAnalysisCubit>();
    final bookingRows = analysisCubit.convertMatchedDataToBookingRows(
      response.matchedData,
    );

    if (bookingRows.isEmpty) {
      AppSnackbar.showTranslated(
        context: context,
        translationKey: 'booking.no_valid_bookings',
        type: SnackbarType.error,
      );
      return;
    }

    // Call the callback to add rows to NewBookingCubit
    onAddToNewBook!(bookingRows);

    // Navigate back to new book screen
    Navigator.of(context).pop();

    // Show success message after navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppSnackbar.showTranslated(
        context: context,
        translationKey: 'booking.bookings_added_to_table',
        type: SnackbarType.success,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentAnalysisCubit, DocumentAnalysisState>(
      builder: (context, state) {
        final isCreating = state is DocumentAnalysisCreating;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.WHITE,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColor.GRAY_HULF),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'booking.analysis_summary'.tr(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildSummaryItem(
                        'booking.total_files'.tr(),
                        '${response.totalFiles}',
                      ),
                      const SizedBox(width: 24),
                      _buildSummaryItem(
                        'booking.successful'.tr(),
                        '${response.successfulFiles}',
                        color: Colors.green,
                      ),
                      const SizedBox(width: 24),
                      _buildSummaryItem(
                        'booking.failed'.tr(),
                        '${response.failedFiles}',
                        color: Colors.red,
                      ),
                    ],
                  ),
                  if (response.errors.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ...response.errors.map((error) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            error,
                            style: const TextStyle(color: Colors.red),
                          ),
                        )),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (response.matchedData.isNotEmpty) ...[
              Text(
                'booking.matched_bookings'.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...response.matchedData.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: MatchedDataCard(
                    index: entry.key,
                    data: entry.value,
                  ),
                );
              }),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isCreating ? null : () => _addToNewBook(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text('booking.add_to_new_book'.tr()),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isCreating ? null : () => _createBookings(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.YELLOW,
                        foregroundColor: AppColor.WHITE,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: isCreating
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColor.WHITE),
                              ),
                            )
                          : Text('booking.create_bookings'.tr()),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildSummaryItem(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColor.GRAY_HULF,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color ?? AppColor.BLACK,
          ),
        ),
      ],
    );
  }
}

