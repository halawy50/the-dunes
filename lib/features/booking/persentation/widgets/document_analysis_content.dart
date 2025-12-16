import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/features/booking/persentation/cubit/document_analysis_cubit.dart';
import 'package:the_dunes/features/booking/persentation/models/new_booking_row.dart';
import 'package:the_dunes/features/booking/persentation/widgets/document_analysis_file_upload.dart';
import 'package:the_dunes/features/booking/persentation/widgets/document_analysis_results.dart';

class DocumentAnalysisContent extends StatelessWidget {
  final void Function(List<NewBookingRow>)? onAddToNewBook;

  const DocumentAnalysisContent({
    super.key,
    this.onAddToNewBook,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<DocumentAnalysisCubit, DocumentAnalysisState>(
      listener: (context, state) {
        if (state is DocumentAnalysisLoaded) {
          // Auto-add to new book if callback is provided and there's matched data
          if (onAddToNewBook != null && state.response.matchedData.isNotEmpty) {
            final analysisCubit = context.read<DocumentAnalysisCubit>();
            final bookingRows = analysisCubit.convertMatchedDataToBookingRows(
              state.response.matchedData,
            );

            if (bookingRows.isNotEmpty) {
              // Add rows to NewBookingCubit
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
          }
        } else if (state is DocumentAnalysisSuccess) {
          AppSnackbar.showTranslated(
            context: context,
            translationKey: state.message,
            type: SnackbarType.success,
          );
        } else if (state is DocumentAnalysisError) {
          AppSnackbar.show(
            context: context,
            message: state.message,
            type: SnackbarType.error,
          );
        }
      },
      child: BlocBuilder<DocumentAnalysisCubit, DocumentAnalysisState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('booking.analyze_documents'.tr()),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const DocumentAnalysisFileUpload(),
                  const SizedBox(height: 24),
                  if (state is DocumentAnalysisLoaded)
                    DocumentAnalysisResults(
                      response: state.response,
                      onAddToNewBook: onAddToNewBook,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

