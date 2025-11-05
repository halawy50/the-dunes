import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/features/booking/persentation/cubit/booking_cubit.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = sl<BookingCubit>();
        cubit.init();
        return cubit;
      },
      child: BlocListener<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingSuccess) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: 'booking.success',
              type: SnackbarType.success,
            );
          } else if (state is BookingError) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: state.message,
              type: SnackbarType.error,
            );
          }
        },
        child: BlocBuilder<BookingCubit, BookingState>(
          builder: (context, state) {
            if (state is BookingLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const Padding(
              padding: EdgeInsets.all(24.0),
              child: Center(
                child: Text('Booking Screen'),
              ),
            );
          },
        ),
      ),
    );
  }
}
