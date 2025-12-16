import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/features/booking/persentation/cubit/document_analysis_cubit.dart';
import 'package:the_dunes/features/booking/persentation/models/new_booking_row.dart';
import 'package:the_dunes/features/booking/persentation/widgets/document_analysis_content.dart';

class DocumentAnalysisScreen extends StatelessWidget {
  final void Function(List<NewBookingRow>)? onAddToNewBook;

  const DocumentAnalysisScreen({
    super.key,
    this.onAddToNewBook,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<DocumentAnalysisCubit>(),
      child: DocumentAnalysisContent(onAddToNewBook: onAddToNewBook),
    );
  }
}

