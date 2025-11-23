import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/features/booking/data/models/booking_model.dart';
import 'package:the_dunes/features/booking/persentation/cubit/booking_cubit.dart';
import 'package:the_dunes/features/booking/persentation/widgets/booking_screen_content.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final List<BookingModel> _selectedBookings = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
  }

  void _handleBookingSelect(BookingModel booking, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedBookings.add(booking);
      } else {
        _selectedBookings.remove(booking);
      }
    });
  }

  void _handleBookingEdit(BookingModel booking, Map<String, dynamic> updates) {
    context.read<BookingCubit>().updateBooking(booking.id, updates);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<BookingCubit>(),
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
            // Initialize on first build
            if (state is BookingInitial) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<BookingCubit>().init();
              });
            }

            if (state is BookingLoading && state is! BookingSuccess) {
              return Container(
                color: AppColor.GRAY_F6F6F6,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            }

            return BookingScreenContent(
              selectedBookings: _selectedBookings,
              searchQuery: _searchQuery,
              onBookingSelect: _handleBookingSelect,
              onBookingEdit: _handleBookingEdit,
              onSearchChanged: (query) {
                setState(() => _searchQuery = query);
              },
            );
          },
        ),
      ),
    );
  }
}
