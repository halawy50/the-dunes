import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
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
        final cubit = di<HotelCubit>();
        cubit.init();
        return cubit;
      },
      child: BlocListener<HotelCubit, HotelState>(
        listener: (context, state) {
          if (state is HotelSuccess) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: 'hotels.success',
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
              return Container(
                color: AppColor.GRAY_F6F6F6,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            }

            return Container(
              width: double.infinity,
              color: AppColor.GRAY_F6F6F6,
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Text(
                  'hotels.title'.tr(),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
