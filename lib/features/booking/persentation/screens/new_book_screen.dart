import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/booking/persentation/cubit/new_booking_cubit.dart';
import 'package:the_dunes/features/booking/persentation/widgets/new_book_content.dart';

class NewBookScreen extends StatelessWidget {
  const NewBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = di<NewBookingCubit>();
        cubit.init();
        return cubit;
      },
      child: BlocListener<NewBookingCubit, NewBookingState>(
        listener: (context, state) {
          if (state is NewBookingSaved) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: 'booking.success',
              type: SnackbarType.success,
            );
            context.go('/booking');
          } else if (state is NewBookingError) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: state.message,
              type: SnackbarType.error,
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColor.GRAY_F6F6F6,
          body: BlocBuilder<NewBookingCubit, NewBookingState>(
            builder: (context, state) {
              if (state is NewBookingLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return const NewBookContent();
            },
          ),
        ),
      ),
    );
  }
}

