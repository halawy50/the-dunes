import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/hotels/persentation/cubit/hotel_cubit.dart';
import 'package:the_dunes/features/hotels/persentation/widgets/hotel_screen_content.dart';

class HotelScreen extends StatelessWidget {
  const HotelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = di<HotelCubit>();
        cubit.init();
        return cubit;
      },
      child: Container(
        width: double.infinity,
        color: AppColor.GRAY_F6F6F6,
        child: const HotelScreenContent(),
      ),
    );
  }
}
