import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/features/hotels/persentation/cubit/hotel_cubit.dart';

class HotelScreen extends StatefulWidget {
  const HotelScreen({super.key});

  @override
  State<HotelScreen> createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = sl<HotelCubit>();
        cubit.init(); 
        return cubit;
      },
      child: BlocListener<HotelCubit, HotelState>(
        listener: (context, state) {
          if (state is HotelSuccess) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: 'hotel.success',
              type: SnackbarType.success,
            );
          } else if (state is HotelError) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: state.message,
              type: SnackbarType.error,
            );
          }
        },
        child: BlocBuilder<HotelCubit, HotelState>(
          builder: (context, state) {
            if (state is HotelLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const Padding(
              padding: EdgeInsets.all(24.0),
              child: Center(
                child: Text('Hotel Screen'),
              ),
            );
          },
        ),
      ),
    );
  }
}
